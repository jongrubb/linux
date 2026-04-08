# Runs mvn package -Pcovereage, compiles jacoco report, and opens the html report in the browser.
function mvn:test:coverage() {
  mvn package -Pcoverage
  mvn jacoco:report -Pcoverage
  local report
  if [[ -d ./target ]]; then
    report="./target/site/jacoco/index.html"
  else
    report=$(find . -path "*/target/site/jacoco/index.html" | head -1)
  fi
  if [[ -n "$report" && -f "$report" ]]; then
    open "$report"
  else
    echo "jacoco index.html not found"
  fi
}

# Prints out help dialogue for all git functions.
function mvn:help() {
  zsh-help ${(%):-%x}
}