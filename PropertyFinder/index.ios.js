/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';
var React = require('react-native');
var SearchPage = require('./SearchPage');
class HelloWorld extends React.Component {
  render() {
    return <React.Text style={styles.text}>HelloWorld!</React.Text>;
  }
}
class PropertyFinderApp extends React.Component {
  render() {
    // return React.createElement(React.Text, {style: styles.text}, "HelloWorld");
    // return <React.Text style={styles.text}>HelloWorld!</React.Text>;
    return (
      <React.NavigatorIOS style={styles.container}
      initialRoute={{
        title: "Property Finder",
        component: SearchPage
      }}/>
    );
  }
}

var styles = React.StyleSheet.create({
  text: {
    color: 'black',
    backgroundColor: 'white',
    fontSize: 30,
    margin: 80,
  },
  container: {
    flex: 1
  }
});

React.AppRegistry.registerComponent('PropertyFinder', function() { return PropertyFinderApp });