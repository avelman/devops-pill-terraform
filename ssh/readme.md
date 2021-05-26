# SSH keys for VM Instances
Create ssh keys (private and public) on this directory; they will be ignored by git.

`ssh-keygen -t rsa -f ./aws-key`

AWS only supports RSA keypairs, it does not support DSA, ECDSA or Ed25519 keypairs. If you try to upload a non RSA public key you will get an error.

Change its permissions after creation.

`chmod 400 aws-key*`