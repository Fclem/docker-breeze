# docker-breeze

breeze :
[![](https://images.microbadger.com/badges/image/fimm/breeze.svg)](https://microbadger.com/images/fimm/breeze "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/fimm/breeze.svg)](https://microbadger.com/images/fimm/breeze "Get your own version badge on microbadger.com")

django :
[![](https://images.microbadger.com/badges/image/fimm/django.svg)](https://microbadger.com/images/fimm/django "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/fimm/django.svg)](https://microbadger.com/images/fimm/django "Get your own version badge on microbadger.com")

Docker containers configuration, lunch and deploy environment for custom django, and for breeze over custom django

Check related isbio repository at https://github.com/Fclem/isbio

How-to :

```console
curl https://goo.gl/VLroxR && ./bootstrap.sh
```
If not logged-out, log-out and login again then
```console
cd dockerb && ./init.sh
```

If using ssh bridge, copy private and public key, config, know_host in a ```.ssh``` folder.

Store any relevant secret into ```code/config/```

Download the R code

Add SSL certificates in the nginx folder

run
```console
./start_all.sh
```

done !

TODO proper doc
