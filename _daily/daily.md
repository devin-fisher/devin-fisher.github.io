# [Daily Notes](http://devin-fisher.github.io/daily/daily.html)
## August 13, 2015
-L <local port>:<tunneled host>:<tunneled port>
```
$ ssh -L 9000:imgur.com:80 user@example.com
```
## March 26, 2015

Clear all Saved Results

The following will show all results and allow you to select the ones you want to remove. 
```
ctr+shift+f10
```

Once selected. Use:
```
del
```
will remove all selected results

## March 05, 2015

Run distwebservices.py with all of it --no parameters

```
./distwebservices.py --no-searchserver --no-feeder --no-retriever --no-fastcgi --no-paster --no-webserver --no-ldpa
```

Log Patterns for the SearchServer:
```
http://IPAddress:30000/cache/logpatterns?log=0&store=0
log=0 OFF
log=1 ON
```

## March 04, 2015
sqlite visual editor, tried using sqliteman.

To use git in an automated script and http address. Use the convental http credentials.  
Like:
```
git push --repo https://name:password@github.com/name/repo.git
```

## March 03, 2015

Compound Query setup for on a new box:
```
sudo yum install docker-io
sudo groupadd docker
sudo gpasswd -a YourUserName docker
sudo systemctl enable docker
reboot
wget http://10.10.10.50/dev/cq_base.tar.gz
gzip -dc cq_base.tar.gz | docker import - cq_base:latest
cd /path/to/sandbox/
sb build
```

Additionally run this command in each sandbox:

```
docker build -t cq_clinical-reports-extension.v60_release.dev webapp/compoundquery
```