build:
	docker build -t voronenko/cdci-port-forwarder:latest .
push:
	docker push voronenko/cdci-port-forwarder:latest
