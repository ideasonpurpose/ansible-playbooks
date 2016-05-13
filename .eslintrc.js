module.exports = {
  root: true,
  env: {
    node: true,
  },
  extends: 'airbnb-base/legacy',
  rules: {
    'func-names': 0,
    'no-console': 0,
    // 'comma-dangle': 0,
    'no-param-reassign': [2, {props: false}],
    'space-before-function-paren': 0
  }
}
