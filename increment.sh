printf "Bumping pubspec.yaml build number... "
perl -i -pe 's/^(version:\s+\d+\.\d+\.\d+\+)(\d+)$/$1.($2+1)/e' pubspec.yaml
perl -i -pe 's/(flutter.js\?v=)(\d+)/$1.($2+1)/e' "web/index.html"
printf "done.\n"