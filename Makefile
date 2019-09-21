CONFIG_DIR=/etc/optimus_primer
BIN_DIR=/usr/bin

install:
	mkdir -p ${CONFIG_DIR}
	cp config/nvidia-blacklist.conf ${CONFIG_DIR}/nvidia-blacklist.conf
	cp config/nvidia-xorg.conf ${CONFIG_DIR}/nvidia-xorg.conf
	cp config/intel-xorg.conf ${CONFIG_DIR}/intel-xorg.conf
	cp config/prod/primer.conf ${CONFIG_DIR}/primer.conf
	echo 'intel' > ${CONFIG_DIR}/current_mode
	gem build optimus_primer
	gem install --local --force --no-user-install --bindir /usr/bin *.gem
