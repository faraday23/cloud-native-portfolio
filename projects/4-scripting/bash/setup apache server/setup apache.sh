# install apache
sudo apt-get install apache2

# set up configuration file
sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bak
sudo nano /etc/apache2/apache2.conf

# configure directory structure
sudo mkdir -p /var/www/example.com/public_html
sudo chown -R $USER:$USER /var/www/example.com/public_html
sudo chmod -R 755 /var/www

# set up the virtual host
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/example.com.conf
sudo nano /etc/apache2/sites-available/example.com.conf

# enable the various apache modules
sudo a2ensite example.com.conf
sudo a2enmod rewrite
sudo a2enmod ssl

# test the apache server
sudo systemctl restart apache2
curl -I example.com

# secure the server
sudo htpasswd -c /etc/apache
