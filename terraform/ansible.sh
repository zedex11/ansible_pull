tags=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/tags?alt=text" -H "Metadata-Flavor: Google")
export tags=$(echo $tags | sed 's/ /,/g')
sudo ansible-pull -o -U git@github.com:obstaclex/ansible_pull.git -t untagged,$tags
