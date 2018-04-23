# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|

  #aumenta el numero de puertos utilizables para la autocorreccion de colisión de puertos, escoge un puerto libre en el rango especificado
  config.vm.usable_port_range = (62500..63000)
  
  #Caja base para las máquinas virtuales
  config.vm.box = "bento/centos-6.7" 
 

  #Script para instalar los grupos "base" y "Development tools"
  #config.vm.provision :shell, path:"instalador.sh"

  config.vm.provider "virtualbox" do |vb|
  # personaliza cuanta memoria ram va a tener cada maquina creada
    vb.memory = "1024"
  end




  IP_MASTERS="192.168.0." #Parte inicial de la ip de la red externa, es para que los master puedan ser accedidos desde otra computadora en la misma red
  IP_RI="192.168." #Parte inicial de la ip interna es de la forma 192.168.#maestro.20#numerodenodo
  NMASTERS = 3 #Numero de masters a crear
  NNODOS = 2 #número de nodos a crear por cada maestro
  n = 200 #número desde el cual inicia a contar la ip
  $defaultnet = "enp96s0f0" #tarjeta de red a utilizar por vagrant


  #Ciclo para la creación de los maestros, el nombre que usa vagrant para identificarlo es diferente al nombre de host(hostname)
  (1..NMASTERS).each do |i|
    #Se genera la cadena para escribir a un archivo llamado hosts que despues va a ser copiado y va a sobreescribir el archivo /etc/hosts
    comando =  "echo -e \"127.0.0.1 localhost\n#{IP_RI}#{i}.#{n} master\n#{IP_RI}#{i}.#{n+1} node1\n#{IP_RI}#{i}.#{n+2} node2\" >> hosts && cp hosts /etc/hosts"


    #crea la maquina virtual llamada master(i)
    config.vm.define "master#{i}" do |master|
      master.vm.hostname = "master" #nombre de host (hostname)
      master.vm.network :public_network, ip: "#{IP_MASTERS}#{200+i}", bridge: $defaultnet #Configura la tarjeta de red especificada para tener una ip en el mismo segmento de red que las de la red del laboratorio
      master.vm.network :private_network, ip: "#{IP_RI}#{i}.#{n}" #Red privada que sirve para conectar a los master con sus nodos, las ip son de la forma 192.168.#master".n para el master y 192.168.#master.n+1/n+2 para los nodos
      master.vm.provision "shell", inline: "#{comando}"#se ejecuta el comando para crear un archivo hosts según las ip en turno
    end #fin de la definicion de la maquina virtual master



      #Ciclo para la creacion de NNodos para cada maestro
      (1..NNODOS).each do |j|
        #Crea nodo con nombre para vagrant node#master#nodo
        config.vm.define "node#{i}#{j}" do |node|
          node.vm.hostname = "node0#{j}" #Nombre de host(hostname) node0#nodo
          node.vm.network :private_network, ip: "#{IP_RI}#{i}.#{n+j}" #red privada cuya ip debe estar en el mismo rango que el de su maestro
          node.vm.provision "shell", inline: "#{comando}" #crea el archivo hosts que es el mismo para el master y sus dos nodos
        end #fin de la creación de los nodos
      end #fin del ciclo de la creacion de los nodos

  end #fin del ciclo de la creación de los master
  
end #fin de la configuración de las maquinas virtuales

