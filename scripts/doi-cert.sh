# work in /tmp
cd /tmp

# Get the DOI cert
curl -O https://apps-int.usgs.gov/ssl/DOIRootCA2.cer

# Start with system certs
# security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain > ~/combined-certs.pem

# Append your corporate cert
# cat /path/to/DOIRootCA2.cer >> ~/combined-certs.pem
 
