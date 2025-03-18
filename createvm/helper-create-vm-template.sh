helper-create-vm-template() {

  # Read the argument and split it on spaces
  local IFS=' ' # Internal Field Separator (splits on spaces)
  local arg
  while read -r arg; do
    case "$arg" in
      defaults)
        # Set values only if they are empty
		[[ -z "$VM_AGENT" ]] && VM_AGENT=1
		[[ -z "$VM_BIOS" ]] && VM_BIOS="ovmf"
		[[ -z "$VM_BOOTORDER" ]] && VM_BOOTORDER="order=scsi0;ide2"
		[[ -z "$VM_COMPUTERNAME" ]] && VM_COMPUTERNAME="$VM_NAME"
		[[ -z "$VM_CORES" ]] && VM_CORES=8
		[[ -z "$VM_DISK_SIZE" ]] && VM_DISK_SIZE=32
		[[ -z "$VM_EFIDISK_SIZE" ]] && VM_EFIDISK_SIZE="4m"
		[[ -z "$VM_MACHINE" ]] && VM_MACHINE="q35"
		[[ -z "$VM_MACHINE_VER" ]] && VM_MACHINE_VER="7.1"
		[[ -z "$VM_MAC_ADDRESS" ]] && VM_MAC_ADDRESS="DE:AD:BE:EF:00:00"
		[[ -z "$VM_MEMORY" ]] && VM_MEMORY=8000
		[[ -z "$VM_NETHW" ]] && VM_NETHW="virtio"
		[[ -z "$VM_NETWORK_BRIDGE" ]] && VM_NETWORK_BRIDGE="vmbr0"
		[[ -z "$VM_NO_EFIDISK" ]] && VM_NO_EFIDISK=0
		[[ -z "$VM_NUMA" ]] && VM_NUMA=0
		[[ -z "$VM_OS_TYPE" ]] && VM_OS_TYPE="win10"
		[[ -z "$VM_PRE_ENROLL_KEYS" ]] && VM_PRE_ENROLL_KEYS=1
		[[ -z "$VM_REPACK" ]] && VM_REPACK="autoboot addvirtio wipeworkdir autowipe"
		[[ -z "$VM_SCSIHW" ]] && VM_SCSIHW="virtio-scsi-single"
		[[ -z "$VM_SOCKETS" ]] && VM_SOCKETS=1
		[[ -z "$VM_START" ]] && VM_START=1
		[[ -z "$VM_STORAGE_DISK" ]] && VM_STORAGE_DISK="local-lvm"
		[[ -z "$VM_STORAGE_ISO" ]] && VM_STORAGE_ISO="local"
		#[[ -z "$VM_CDROM" ]] && VM_CDROM="$VM_STORAGE_ISO:$VM_REPACKED_ISO,media=cdrom"
		[[ -z "$VM_TEMPLATE_FILENAME" ]] && VM_TEMPLATE_FILENAME="Win10_22H2_EnglishInternational_x64.iso"
		[[ -z "$VM_VIRTIO_FILENAME" ]] && VM_VIRTIO_FILENAME="virtio-win-latest.iso"
		#[[ -z "$VM_WINDOWS_SETTINGS" ]] && VM_WINDOWS_SETTINGS="ControlPanelClassicView ControlPanelLargeIconSize PasswordDontExpires"
		# AddThisPCDesktop  AddThisPCDesktopAllUsers  AddUsersFilesIconAllUsers  AllowConnectingSharesWithoutPassword  DeleteTaskbarPinnedApps  DisableHibernation  DisableLockScreen  DisableLoginAfterSleep  DisableMeetNow  DisableMeetNowAllUsers  DisableScreensaver  DisableScrollForwardInConsole  DisableStickyKeys  EnableFilePrinterSharing  EnableGuestAccount  EnablePowershellScripts  KillEdge  KillOnedrive  RemoveWallpaper  SetAppDarkMode  SetBackgroundDarkGrey  SetSystemDarkMode  Show24HourTime  ShowAllIconsInSystray  ShowFileExtensions  ShowHiddenFiles  ShowSecondsOnTaskbar  SwitchToHighPerformancePlan  TurnOffCortanaButton  TurnOffSearchBox  TurnOffTaskViewButton 
		#    DisableLoginAfterSleep DisableMeetNow   DisableMeetNowAllUsers DisableScreensaver  DisableScrollForwardInConsole  DisableStickyKeys  EnableFilePrinterSharing  EnableGuestAccount  EnablePowershellScripts  KillEdge  KillOnedrive  RemoveWallpaper  SetAppDarkMode  SetBackgroundDarkGrey  SetSystemDarkMode  Show24HourTime  ShowAllIconsInSystray  ShowFileExtensions  ShowHiddenFiles  ShowSecondsOnTaskbar  SwitchToHighPerformancePlan  TurnOffCortanaButton  TurnOffSearchBox  TurnOffTaskViewButton
		# [[ -z "$VM_WINDOWS_SETTINGS" ]] && VM_WINDOWS_SETTINGS=" debug DisableScrollForwardInConsole test7 555"
		
		[[ -z "$VM_WINDOWS_SETTINGS" ]] && VM_WINDOWS_SETTINGS=" TurnOffNewsAndInterestv3 "
		#[[ -z "$VM_WINDOWS_SETTINGS" ]] && VM_WINDOWS_SETTINGS=" debugspc2 Multicommandtest ShowAllIconsInSystray AddThisPCDesktop DisableHibernation EnableGuestAccount  SetBackgroundDarkGrey  ShowFileExtensions ShowSecondsOnTaskbar TurnOffCortanaButton TurnOffSearchBox TurnOffTaskViewButton DisableScrollForwardInConsole "
		#SetAppDarkMode SetSystemDarkMode RemoveWallpaper CreateDefaultStartLayoutFile
		#[[ -z "$VM_WINDOWS_SETTINGS" ]] && VM_WINDOWS_SETTINGS=" DisableScreenSaver DeleteEdgeShortcut  DisableHibernation    Show24HourTime    RemoveAppx Microsoft.WindowsMaps DisableLockScreen DisableLoginAfterSleep DisableMeetNow EnableFilePrinterSharing EnablePowershellScripts "
		
		
		#[[ -z "$VM_WINDOWS_SETTINGS" ]] && VM_WINDOWS_SETTINGS=" debugmsg thisisatest debug DisableScrollForwardInConsole test7 555  ShowAllIconsInSystray DisableScreenSaver  DeleteEdgeShortcut  RemoveAppx Microsoft.WindowsMaps AddThisPCDesktop  AddThisPCDesktopAllUsers  AddUsersFilesIconAllUsers  AllowConnectingSharesWithoutPassword  DeleteTaskbarPinnedApps  DisableHibernation  DisableLockScreen  DisableLoginAfterSleep  test7 557 DisableMeetNow  DisableMeetNowAllUsers test7 558 DisableStickyKeys  EnableFilePrinterSharing  EnableGuestAccount  EnablePowershellScripts test7 559 KillEdge  KillOnedrive test7 560 RemoveWallpaper  SetAppDarkMode  SetBackgroundDarkGrey  SetSystemDarkMode test7 561 Show24HourTime  ShowAllIconsInSystray  ShowFileExtensions test7 562 ShowHiddenFiles  ShowSecondsOnTaskbar  SwitchToHighPerformancePlan test7 563 TurnOffCortanaButton  TurnOffSearchBox  TurnOffTaskViewButton test7 564"
		#VM_WINDOWS_SETTINGS+=" UninstallOneDrive ListUserAppx debug test7 580 " #  TurnOffNewsAndInterestv3     CreateDefaultStartLayoutFile   "
		#VM_WINDOWS_SETTINGS+=" CreateDefaultStartLayoutFile ListUserAppx TurnOffNewsAndInterestv3 UninstallOneDrive test7 580 debug debugmsg thisisatest RemoveAppx Microsoft.WindowsCalculator RemoveAppxUser Microsoft.WindowsFeedbackHub RemoveAppxAllUser Microsoft.YourPhone"
		#VM_WINDOWS_SETTINGS+=" debug debugmsg 'this is a test test' writetmpfile my.temp.file.text writetmpfile.test.txt addregstr 'HKEY_CURRENT_USER\Software\TestCompany' 'TestValue' 'Success' addtask '"echo this is a test task > %tmp%\scheduled.test.task.txt"' 'sc' "
		# SetStartMenuTilesLocked ResetStartMenuTiles SetStartMenuTilesUnLocked MountGuestNetworkShare user z: '\\shodan.lan\guest' TurnOffNewsAndInterestv2 DisableContentDeliveryManager
		#[[ -z "$VM_WINDOWS_SETTINGS" ]] && VM_WINDOWS_SETTINGS="SetBackgroundDarkGrey SetAppDarkMode SetSystemDarkMode ControlPanelLargeIconSize ControlPanelClassicView PasswordDontExpires"
		#[[ -z "$VM_WINDOWS_SETTINGS" ]] && VM_WINDOWS_SETTINGS="SetBackgroundDarkGrey"
		#[[ -z "$VM_WINDOWS_SETTINGS" ]] && VM_WINDOWS_SETTINGS="test 1 ControlPanelClassicView test 2 ControlPanelLargeIconSize test 3 PasswordDontExpires test 4 SetBackgroundDarkGrey test 5 SetAppDarkMode test 6 SetSystemDarkMode test 7"
		#[[ -z "$VM_WINDOWS_SETTINGS" ]] && VM_WINDOWS_SETTINGS="test4 RemoveWallpaper SetBackgroundDarkGrey test4 SetAppDarkMode SetSystemDarkMode test6 test4"
		[[ -z "$VM_WAFG" ]] && VM_WAFG="computername \"${VM_COMPUTERNAME:-$VM_NAME}\""
		[[ ${#VM_SCSI[@]} -eq 0 ]] && VM_SCSI+=("$VM_STORAGE_DISK:$VM_DISK_SIZE,backup=0,cache=writeback,discard=on,iothread=1")
		[[ ${#VM_NET[@]} -eq 0 ]] && VM_NET+=("model=$VM_NETHW,macaddr=$VM_MAC_ADDRESS,bridge=$VM_NETWORK_BRIDGE")
		;;
      spice)
        # Enable SPICE-related settings
        [[ -z "$VM_VGA" ]] && VM_VGA="qxl"
        [[ -z "$VM_SPICE_VIDEO_STREAMING" ]] && VM_SPICE_VIDEO_STREAMING="all"
        ;;
      
      *)
        echo "⚠️ Warning: Unknown template keyword '$arg'"
        ;;
    esac
  done <<< "$1"
}