locals {
  subscription_id     = "00000000-0000-0000-0000-000000000000"
  vm_name             = "ExampleVmName"
  resource_group_name = "ExampleResourceGroupName"
}


#----------------------------------------------------
# PowerShell Script
#----------------------------------------------------

resource "null_resource" "script_powershell" {

  triggers = {
    param0       = "some parameter"
    param1       = "some parameter"
    secureParam0 = "something secret"
    secureParam1 = "something secret"
  }

  provisioner "local-exec" {
    command = join(" ", [
      "az vm run-command invoke",
      "--command-id RunPowerShellScript",
      "--subscription", local.subscription_id,
      "--name", local.vm_name,
      "--resource-group", local.resource_group_name,
      "--scripts `@${path.module}/tf_azvmwin_script.ps1",
      "--parameters",
      "\"param0=${self.triggers.param0}\"",
      "\"param1=${self.triggers.param1}\"",
      "\"secureParam0=$Env:secureParam0\"",
      "\"secureParam1=$Env:secureParam1\""
    ])
    interpreter = ["PowerShell", "-Command"]
    environment = {
      secureParam0 = self.triggers.secureParam0
      secureParam1 = self.triggers.secureParam1
    }
  }
}
