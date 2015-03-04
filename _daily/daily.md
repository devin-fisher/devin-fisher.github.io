# Daily Notes
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
docker build -t cq_clinical-reports-extension.v60_release.dev /path/to/run/webapp/compoundquery/
```
