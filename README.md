# My Cyberpunk

Website written on ZX Spectrum basic. Or at least fixture to run ZX Spectrum emulator 
at your web page.

### Run dev server
```
npm start
```

### Compile basic source
```
npm bas2tap
```
You need "bas2tap" installed within your $PATH

### Build web bundle
```
npm build
```

### Make docker image

##### Prerequisites

1. You need "docker" installed.
2. A self-signed certificate for nginx will be generated when building. Further
it can be replaced. 

3. Key generation requires a fair amount of entropy. Docker uses host machine
entropy source. Therefore, to speed up the build it is recommended to install
haveged
```
sudo apt-get install haveged
sudo service haveged start 
```

##### Image building

```
sudo npm docker:build -- [<parameters>]
```

For each parameter you need to specify:

```
--build-arg <parameter_name>=<value>
```

##### Available parameters

| Parameter              | Description                |
| ---------------------- |:---------------------------|
| site_url               | Deploying URL              |
| maintainer_email       | Email to generate SSL key  |