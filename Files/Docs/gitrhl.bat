echo "# RHL" >> README.md
git init
git add README.md
git config --global user.email "serge.semashko@gmail.com"
git config --global user.name "serge-semashko"
git config --global user.password "bebeka60"
git commit -m "first commit"
git remote add origin https://github.com/serge-semashko/RHLn.git
git push -u origin master