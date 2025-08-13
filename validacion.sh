#!/bin/sh
echo "=== Información del sistema ==="
cat /etc/issue
echo "\n=== Veracode CLI ==="
veracode --version
echo "\n=== Java JDK ==="
java -version
echo "\n=== Veracode Pipeline Scan ==="
java -jar /opt/veracode/pipeline-scan.jar --version --format json
echo "\n=== Jackson-databind Version ==="
java -cp /opt/veracode/pipeline-scan.jar com.fasterxml.jackson.databind.ObjectMapper --version 
echo "\n=== Veracode API Signing ==="
python3 -c "import veracode_api_signing; print('Import OK')"
pip show veracode-api-signing
echo "\n=== Veracode API Wrapper ==="
java -jar /opt/veracode/VeracodeJavaAPI.jar -wrapperversion
echo "\n=== Maven ==="
mvn -v
echo "\n=== Gradle ==="
gradle -v
