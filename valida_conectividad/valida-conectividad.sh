#/bin/sh

echo "======================================================="
echo "== [INFO] Testing connectivity to Veracode Services  =="
echo "======================================================="
echo ""
echo ""

pwd
ls -all
echo $PATH
echo $HOME
cat ~/.veracode/credentials
echo ""
echo ""

# Testing connectivity with Veracode CLI tool
# As a result it should bring a policy from tenant, as a file. Also,
# it 'cat' the file
echo "-------------------------------------------------------------"
echo "[INFO] Testing Veracode CLI tool"
echo "-------------------------------------------------------------"
veracode policy get "Veracode Recommended High"
cat "Veracode Recommended High"
echo "-------------------------------------------------------------"
echo ""
echo ""

# Testing connectivity with Veracode Java API Wrapper
# Java API Wrapper is invoked by Veracode Plugin for Jenkins at runtime
# As a result it should bring a list with all app profiles in tenant
INSTALL_DIR="/opt/veracode"
#INSTALL_DIR="$HOME/tools/veracode"
ARTIFACT_NAME="VeracodeJavaAPI.jar"
echo "-------------------------------------------------------------"
echo "[INFO] Testing Veracode Java API Wrapper"
echo "-------------------------------------------------------------"
java -jar $INSTALL_DIR/$ARTIFACT_NAME -action getapplist
echo "-------------------------------------------------------------"
echo ""
echo ""

# Testing connectivity with Veracode SRCCLR API
# As a result it should bring a list with all workspaces in tenant
echo "-------------------------------------------------------------"
echo "[INFO] Testing Veracode SRCCLR API"
echo "-------------------------------------------------------------"
http --auth-type veracode_hmac GET https://api.veracode.com/srcclr/v3/workspaces
echo "-------------------------------------------------------------"
echo ""
echo ""
