{# vi: set ft=jinja : #}

chage --lastday=0 {{ domain.init.user.username }}
systemctl enable serial-getty@ttyS0.service
systemctl disable --now cloud-init.service cloud-init-local.service cloud-config.service cloud-final.service

{% if ansible_os_family == "Debian" %}
  apt-get update --yes;
  apt-get purge --yes cloud-init;
  apt-get autoremove;
  apt-install --yes openssh-server;
  systemctl enable openssh-server;
{% else %} 
  dnf remove --yes cloud-init;
  yum remove --yes cloud-init;
  dnf install --yes openssh-server;
  systemctl enable openssh-server;
{% endif %}
