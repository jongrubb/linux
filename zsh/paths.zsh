path+="${PROJECT_ROOT:+$PROJECT_ROOT/node_modules/.bin}"
path+=$(pnpm bin --global 2> /dev/null)
path+='/Applications/IntelliJ IDEA.app/Contents/MacOS'