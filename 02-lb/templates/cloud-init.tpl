#cloud-config

users:
  - name: ${user}
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ${ssh_public_key}

package_update: true

runcmd:
  - |
    cat <<EOF > /var/www/html/index.html
    Hostname - $(hostname)<br>
    Internal IP-address - $(hostname -I)<br>
    Link to bucket - <a href="https://storage.yandexcloud.net/novitskiiva-tfstate-k8s/k8s-infra/test?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=YCAJE6ts2tV0pX-TZ%2F20251122%2Fru-central1%2Fs3%2Faws4_request&X-Amz-Date=20251122T101339Z&X-Amz-Expires=3600&X-Amz-Signature=ba09792e7f551bd8ea187d5448383e93073d373ba66&X-Amz-SignedHeaders=host&response-content-disposition=attachment">storage.yandexcloud.net</a>
    EOF
