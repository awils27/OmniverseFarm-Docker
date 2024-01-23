#!/bin/bash

#
# Note: Specific package versions can be retrieved from the Omniverse Launcher.
#

# Install the Omniverse Farm Queue package, containing the core Queue capabilities:
mkdir -p ov-farm-queue
cd ov-farm-queue
pwd
curl https://d4i3qtqj3r0z5.cloudfront.net/farm-queue-launcher%40105.1.0%2B105.1.x.174.c6feac39.teamcity.linux-x86_64.release.zip > farm-queue-launcher.zip
unzip farm-queue-launcher.zip
rm farm-queue-launcher.zip

# patch the 105.1.0 headless release that shipped referencing old modules that cause errors
sed -i'.backup' 's/\t"omni\.services\.farm\.management\.tasks-0\.19\.3"/\t"omni\.services\.farm\.management\.tasks-0\.19\.4"/g' apps/omni.farm.queue.headless.kit
sed -i'.backup' 's/\t"omni\.services\.farm\.facilities\.store\.db-0\.11\.2"/\t"omni\.services\.farm\.facilities\.store\.db-0\.11\.3"/g' apps/omni.farm.queue.headless.kit

# Install the Kit SDK package, containing the set of features and extensions shared by Omniverse applications:
mkdir kit
cd kit
pwd
curl https://d4i3qtqj3r0z5.cloudfront.net/kit-sdk-launcher@105.1%2Bmaster.120930.709ebe37.tc.linux-x86_64.release.zip > kit-sdk-launcher.zip
unzip kit-sdk-launcher.zip
rm kit-sdk-launcher.zip

cd ..

# Create a boilerplate launch script for the Queue:
cat << 'EOF' > queue.sh
#!/bin/bash

BASEDIR=$(dirname "$0")
exec $BASEDIR/kit/kit $BASEDIR/apps/omni.farm.queue.headless.kit \
    --ext-folder $BASEDIR/exts-farm-queue \
    --/exts/omni.services.farm.management.tasks/dbs/task-persistence/connection_string=sqlite:///$BASEDIR//task-management.db
EOF

chmod +x queue.sh