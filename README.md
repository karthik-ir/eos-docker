# eos-docker
Docker image for eos contract Developement

This image was created with the need to begin contract development on EOS rightaway 
without going through the pain of making build with associated dependencies.


This image is based on dawn-2.x branch. (Additions to branch specific builds coming soon)

Just set the volume parameters for `docker-compoese.yml` and do `docker-compose up -d`
This should spawn `eosd` in the background.

And with clion directory mapping as volume, you can spawn the IDE using 
`docker exec -it eosdocker_eosiod_1 clion.sh`

Now the IDE runs within the container and you can do all your development in the IDE including running eosc commands in the 
IDE terminal. 

For information on setting up the project scaffold, 
refer to https://steemit.com/eos/@ukarlsson/eos-contracts-development-with-the-clion-ide. 
