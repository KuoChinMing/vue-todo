# https://cli.vuejs.org/zh/guide/deployment.html#github-pages

# 当发生错误时中止脚本
set -e

# 构建
# 要先安裝 vue-cli 與 @vue/cli-service-global
# npm install -g vue-cli @vue/cli-service-global
vue build App.vue

# cd 到构建输出的目录下 
cd dist

# 部署到自定义域域名
# echo 'www.example.com' > CNAME

git init
git add -A
git commit -m 'deploy'

# 部署到 https://<USERNAME>.github.io/<REPO>
git push -f https://github.com/KuoChinMing/vue-todo.git master:gh-pages

cd -