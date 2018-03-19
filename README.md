# eos-docker
Docker image for eos contract Developement

This image was created with the need to begin contract development on EOS rightaway 
without going through the pain of making build with associated dependencies.

This image is based on dawn-2.x branch. (Additions to branch specific builds coming soon)

Just set the volume parameters for `docker-compoese.yml` and do `docker-compose up -d`
This should spawn `eosd` in the background.

`alias eosioc='docker-compose exec eosiod /opt/eos/bin/eosc''`

Then you can use `eosioc` for all the commands like wallet creation,importing for keys etc. 

All operation on eosiod will persist data in the Volume that is set for data-dir 
And can be used for all persistence of the `config.ini` or `contracts` or `wallet.keys`

Download CLion, extract it and add the path to the volume of clion. Also create a clion-data directory in host for persisting
value of IDE configuration.

Inorder to allow the container gain access to the host display you need to provide permission.
Run the following commands.

```
xhost +local:docker
xhost +
```

And with clion directory mapping as volume, you can spawn the IDE from within the container using 
`docker exec -it eosdocker_eosiod_1 clion.sh`

Now the IDE runs within the container and you can do all your development in the IDE including running eosc commands in the 
IDE terminal. From the terminal of the IDE

Run : 
`eoscpp -n {CONTRACT_NAME}` to create a contract scaffold. 
Copy the CMakeLists.txt and Toolchain.cmake from /dev-tools to the contract folder, change the project name in the CMakeLists.txt. 

Expected folder structure :
Contract_Folder
-src - Contains .cpp files
-include - contains header files
contain .abi file. 

For information on setting up the project scaffold for working on clion, 
refer to https://steemit.com/eos/@ukarlsson/eos-contracts-development-with-the-clion-ide. 
