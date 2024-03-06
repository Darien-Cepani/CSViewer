docker build -t my-svelte-app .
docker run --rm my-svelte-app tar cz dist > dist.tar.gz      
tar xvz -f dist.tar.gz
