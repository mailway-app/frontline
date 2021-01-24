VERSION = 1.0.0
DEST = $(PWD)/dist/frontline-nginx

.PHONY: clean
clean:
	rm -rf $(DEST) *.deb

$(DEST)/usr/local/sbin/frontline-nginx:
	mkdir -p $(DEST)/usr/local/sbin/
	docker build -t frontline-nginx .
	docker run -it \
		-u $(id -u ${USER}):$(id -g ${USER}) \
		-v $(DEST)/usr/local/sbin/:/tmp/out/frontline-nginx \
		frontline-nginx \
		cp -v objs/nginx /tmp/out/frontline-nginx/frontline-nginx
	mkdir -p $(DEST)/usr/local/nginx/logs/ $(DEST)/etc/ssl \
		$(DEST)/var/log/frontline-nginx-http/ \
		$(DEST)/var/log/frontline-nginx/

.PHONY: deb
deb: $(DEST)/usr/local/sbin/frontline-nginx
	fpm -n frontline -s dir -t deb --chdir=$(DEST) --version=$(VERSION)
