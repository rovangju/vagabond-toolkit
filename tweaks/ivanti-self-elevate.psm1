<#
    .Synopsis
    This module can be used to invoke the Self-Elevation functionality of
    Ivanti AppSense Application Manager

    .Description
    This module uses the AMShellIntegration.AMShellContextMenu COM component to
    invoke the Self-Elevation functionality of Ivanti AppSense Application 
    Manager.

    When enabled, Self-Elevation can be used to run (selected) applications
    with Administrator privileges. Generally, this functionality is only
    exposed from Windows Explorer. Using this module, it is possible to call
    this component directly (with arbitrary arguments).

    .Example
    Import-Module .\Start-ProcessAMSelfElevate.psm1
    Start-ProcessAMSelfElevate -FilePath cmd.exe -ArgumentList /k,calc.exe -WorkingDirectory $env:USERPROFILE
#>
Function Start-ProcessAMSelfElevate {
Param([Parameter(Position = 0, Mandatory = $true)] [string]$FilePath,
    [Parameter(Position = 1, Mandatory = $false)] [string[]]$ArgumentList,
    [Parameter(Position = 2, Mandatory = $false)] [string]$WorkingDirectory)
    If ([Environment]::Is64BitProcess -ne [Environment]::Is64BitOperatingSystem) {
        Throw "Please load this module in a 64-bit PowerShell"
    }

    Add-Type -Language CSharp -ErrorAction SilentlyContinue -TypeDefinition @"
    using System;
    using System.Text;
    using System.Runtime.InteropServices;
    using System.Runtime.InteropServices.ComTypes;

    namespace AMShellIntegration
    {
        public class AMShellContextMenu
        {
            private const string Verb = "AppSenseSelfElevate";

            public static void InvokeCommand(string FilePath) { InvokeCommand(FilePath, null, Environment.GetFolderPath(Environment.SpecialFolder.Desktop)); }
            public static void InvokeCommand(string FilePath, string CommandLine) { InvokeCommand(FilePath, CommandLine, Environment.GetFolderPath(Environment.SpecialFolder.Desktop)); }
            public static void InvokeCommand(string FilePath, string CommandLine, string WorkingDirectory)
            {
                IAMShellContextMenu pAMShellContextMenu = new IAMShellContextMenu();
                IShellExtInit pShellExtInit = (IShellExtInit)pAMShellContextMenu;
                pShellExtInit.Initialize(IntPtr.Zero, new DataObject(FilePath), 0);
                CMINVOKECOMMANDINFOEX ici = new CMINVOKECOMMANDINFOEX();
                ici.cbSize = Marshal.SizeOf(ici);
                ici.lpVerb = Verb;
                ici.lpVerbW = Verb;
                ici.lpParameters = CommandLine;
                ici.lpParametersW = CommandLine;
                ici.lpDirectory = WorkingDirectory;
                ici.lpDirectoryW = WorkingDirectory;
                ici.fMask = 65536 /* CMIC_MASK_UNICODE */;
                ici.nShow = 1 /* SW_SHOWNORMAL */;
                IContextMenu pContextMenu = (IContextMenu)pAMShellContextMenu;
                pContextMenu.InvokeCommand(ref ici);
            }

            [ComImport]
            [ComVisible(true)]
            [Guid("EA9F2D67-30A0-45C7-941B-5EF96480851A")]
            private class IAMShellContextMenu { }

            [ComImport()]
            [Guid("000214e8-0000-0000-c000-000000000046")]
            [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
            private interface IShellExtInit
            {
                [PreserveSig()]
                int Initialize(IntPtr pidlFolder, IDataObject lpdobj, uint hKeyProgID);
            }

            [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
            private struct POINT
            {
                public int x;
                public int y;
            }

            [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
            private struct CMINVOKECOMMANDINFOEX
            {
                public int cbSize;
                public int fMask;
                public IntPtr hwnd;
                [MarshalAs(UnmanagedType.LPStr)]
                public string lpVerb;
                [MarshalAs(UnmanagedType.LPStr)]
                public string lpParameters;
                [MarshalAs(UnmanagedType.LPStr)]
                public string lpDirectory;
                public int nShow;
                public int dwHotKey;
                public IntPtr hIcon;
                [MarshalAs(UnmanagedType.LPStr)]
                public string lpTitle;
                [MarshalAs(UnmanagedType.LPWStr)]
                public string lpVerbW;
                [MarshalAs(UnmanagedType.LPWStr)]
                public string lpParametersW;
                [MarshalAs(UnmanagedType.LPWStr)]
                public string lpDirectoryW;
                [MarshalAs(UnmanagedType.LPWStr)]
                public string lpTitleW;
                public POINT ptInvoke;
            }

            [ComImport()]
            [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
            [Guid("000214e4-0000-0000-c000-000000000046")]
            private interface IContextMenu
            {
                [PreserveSig()]
                int QueryContextMenu(IntPtr hmenu, uint indexMenu, uint idCmdFirst, uint idCmdLast, uint uFlags);
                [PreserveSig()]
                int InvokeCommand(ref CMINVOKECOMMANDINFOEX pici);
                [PreserveSig()]
                int GetCommandString(uint idCmd, uint uType, IntPtr pReserved, [MarshalAs(UnmanagedType.LPArray)]byte[] pszName, int cchMax);
            }

            [StructLayout(LayoutKind.Sequential)]
            private struct DROPFILES
            {
                public int pFiles;
                public int X;
                public int Y;
                public bool fNC;
                public bool fWide;
            }

            private class DataObject : IDataObject
            {
                private string m_Path;
                public DataObject(string Path) { m_Path = Path; }

                public void GetData(ref FORMATETC format, out STGMEDIUM medium)
                {
                    if (format.cfFormat != 15 /* CF_HDROP */)
                    {
                        throw new FormatException();
                    }

                    byte[] files = new byte[m_Path.Length * 2 + 4];
                    Buffer.BlockCopy(Encoding.Unicode.GetBytes(m_Path), 0, files, 0, m_Path.Length * 2);
                    DROPFILES dropfiles = new DROPFILES();
                    dropfiles.pFiles = Marshal.SizeOf(dropfiles);
                    dropfiles.fWide = true;
                    medium = new STGMEDIUM();
                    medium.tymed = TYMED.TYMED_HGLOBAL;
                    medium.unionmember = Marshal.AllocHGlobal(Marshal.SizeOf(dropfiles) + files.Length);
                    medium.pUnkForRelease = IntPtr.Zero;
                    Marshal.StructureToPtr(dropfiles, medium.unionmember, false);
                    Marshal.Copy(files, 0, medium.unionmember + dropfiles.pFiles, files.Length);
                }
                public void GetDataHere(ref FORMATETC format, ref STGMEDIUM medium) { throw new NotImplementedException(); }
                public int QueryGetData(ref FORMATETC format) { throw new NotImplementedException(); }
                public int GetCanonicalFormatEtc(ref FORMATETC formatIn, out FORMATETC formatOut) { throw new NotImplementedException(); }
                public void SetData(ref FORMATETC formatIn, ref STGMEDIUM medium, bool release) { throw new NotImplementedException(); }
                public IEnumFORMATETC EnumFormatEtc(DATADIR direction) { throw new NotImplementedException(); }
                public int DAdvise(ref FORMATETC pFormatetc, ADVF advf, IAdviseSink adviseSink, out int connection) { throw new NotImplementedException(); }
                public void DUnadvise(int connection) { throw new NotImplementedException(); }
                public int EnumDAdvise(out IEnumSTATDATA enumAdvise) { throw new NotImplementedException(); }
            }
        }
    }
"@
    [AMShellIntegration.AMShellContextMenu]::InvokeCommand($FilePath, $($ArgumentList -Join " "), $WorkingDirectory)
}

Export-ModuleMember -Function Start-ProcessAMSelfElevate
