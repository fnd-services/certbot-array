#!/usr/local/bin/bash
# This script loops through an array of domains to generate SSL certificates
# for each of them using Let's Encrypt service.
# Developed for FreeBSD 12, adjust paths if you're using Linux

# Distributed with 3-Clause BSD license, make sure to read license file
# Author kpetrilli

# Define some variables
live_dir="/usr/local/etc/letsencrypt/live"
cert_dir="/usr/local/etc/nginx/certificates"
email="info@example.com"

# Define domains
domains=(
		'example.com'
		'example.org'
	)

for d in "${domains[@]}"
do
   if ! certbot certonly \
	--quiet \
	--standalone \
	--non-interactive \
	--agree-tos \
	--email "$email" \
	--no-eff-email \
	--force-renewal \
	--preferred-challenges http \
	--domain "$d" \
	--cert-name "$d" \
   then
	echo "Error renewing:  $"
   else
	cp -RLf "$live_dir/$d" "$cert_dir/"
	chown -R www:www "$cert_dir/$d"
	echo "Renewed: $"
   fi
done
