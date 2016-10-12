# docker-breeze
[![](https://images.microbadger.com/badges/image/fimm/breeze.svg)](https://microbadger.com/images/fimm/breeze "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/fimm/breeze.svg)](https://microbadger.com/images/fimm/breeze "Get your own version badge on microbadger.com")

Docker containers configuration, lunch and deploy environment for custom django, and for breeze over custom django

Check related isbio repository at https://github.com/Fclem/isbio

How-to :

```console
git clone https://github.com/Fclem/docker-breeze.git

./init.sh
```

Copy private and public key, config, know_host in a ```.ssh``` folder.

Store any relevent secret into ```code/config/```

```console
./run.sh
```

done !

TODO proper doc
