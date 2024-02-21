#!/bin/bash
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
    
yum  update -y
# yum install -y util-linux e2fsprogs
yum install git -y

# # Wait for the volume to be attached
while [ ! -e /dev/nvme2n1 ]; do sleep 1; done

block_size=$(blockdev --getsize64 /dev/nvme2n1 | awk '{print $1/1024/1024/1024 " GB"}')
export block_size
export caves_vol

 # check this against mount volume size
if [ "$block_size" = "100GB" ]; then
    caves_vol=/dev/nvme2n1
else
    caves_vol=/dev/nvme1n1
fi

# Create a file system on the volume if it does not have one
file -s $caves_vol | grep -q ext4 || mkfs -t ext4 $caves_vol
# Create a mount point
mkdir /mnt/caves_of_steel
# Mount the EBS volume
mount $caves_vol /mnt/caves_of_steel
chown ec2-user:ec2-user /mnt/caves_of_steel
# Add an entry to /etc/fstab to mount the volume on reboot
`echo "$caves_vol /mnt/caves_of_steel ext4 defaults,nofail 0 2" >> /etc/fstab`
              
sudo -u ec2-user  bash <<'EOF'
# install zsh
sudo yum install -y zsh util-linux-user
sudo chsh -s /usr/bin/zsh ec2-user

sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

echo -e "\nalias ll='ls -la'" >> ~/.zshrc
 zsh ~/.zshrc

/opt/conda/bin/conda init zsh
/opt/conda/bin/mamba init zsh

conda update -n base -c defaults conda -y
mamba update -n base -c defaults mamba -y

echo -e "\nTRANSFORMERS_CACHE=/mnt/caves_of_steel/.cache/torch/transformers" >> ~/.zshrc
echo -e "\nTRANSFORMERS_CACHE" >> ~/.zshrc

source ~/.zshrc
EOF

# echo "mamba create -n models -y pytorch torchvision torchaudio cudatoolkit=11.8 transformers -c pytorch -c huggingface" > /mnt/caves_of_steel/load_olma.sh



              