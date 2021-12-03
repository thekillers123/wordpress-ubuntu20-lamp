#!/bash/bash
#Note if running non fixed IP will need to install ddclient with a DNS to ensure when instance shutdown new IP address is integrated
#Update and Upgrade
sudo apt -y update
sudo apt -y upgrade
sudo apt -y autoremove

#Install Apache2
sudo apt -y install apache2

#Install php7.4
sudo apt -y install php7.4 php7.4-mysql php-common php7.4-cli php7.4-json php7.4-common php7.4-opcache libapache2-mod-php7.4

#Restart Apache2 server
sudo systemctl restart apache2

#Enable mod_rewrite
sudo a2enmod rewrite

#Restart Apache2 server
sudo systemctl restart apache2

#Install MariaDB
sudo apt -y install mariadb-server mariadb-client most tree zip unzip

#Download and unzip Wordpress to apache directory
sudo wget https://wordpress.org/latest.zip
cd /var/www
sudo unzip /home/ubuntu/latest.zip
sudo rm -Rf html
sudo mv wordpress html

#Setup permissions
sudo chown -Rc www-data:www-data html
sudo chmod -Rc 755 html

#Install phpmyadmin (Apache2, no to config option)
sudo apt -y install phpmyadmin

#Mysql secure install, need phpmyadmin root password, Y/Y/Y/Y to setup options
sudo mysql_secure_installation
sudo systemctl restart mysqld

#Setup wordpress database where -p*password* and identified by *password*
sudo mysql -uroot -p*password* -e 'FLUSH PRIVILEGES;'
sudo mysql -uroot -p*password* -e "ALTER USER 'root'@'localhost'IDENTIFIED BY '*password*';"
sudo mysql -uroot -p*password* -e 'FLUSH PRIVILEGES;'
sudo mysql -uroot -p*password* -e "UPDATE mysql.user SET host='%' WHERE user='root';"
sudo mysql -uroot -p*password* -e 'FLUSH PRIVILEGES;'
sudo mysql -uroot -p*password* -e 'CREATE DATABASE wordpress;'

#Add virtual host config for apache2 for wordpress directory
cat <<'EOF' | sudo tee /etc/apache2/sites-available/domain.com.conf
<VirtualHost *:80>
    ServerName domain.com 
    ServerAdmin webmaster@domain.com 
    DocumentRoot /var/www/html
    <Directory /var/www/html>
         Allowoverride all
   </Directory>
</VirtualHost>
EOF

#Restart Apache2 server
sudo systemctl restart apache2