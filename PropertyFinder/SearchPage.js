'use strict';

var React = require('react-native');
var {
	StyleSheet,
	Text,
	TextInput,
	View,
	TouchableHighlight,
	ActivityIndicatoeIOS,
	Image,
	Component
} = React;
// 每一个React 逐渐都带有一个key-value的状态对象，必须在组建渲染之前设置其初始状态。
class SearchPage extends React.Component {
	render() {

		constructor(props) {
			super(props);
			this.state = {
				searchString: 'london' // 状态变量，初始值为london
			};
		}


		return (
			<View style={styles.container}>
				<Text style={styles.description}>
					Search for houses to buy!
				</Text>
				<Text style={styles.description}>
					Search by place-name, postcode or search near you location.
				</Text>

				<View style={styles.flowRight}>
					<TextInput style={styles.searchInput}
						placeholder='Search via name or postcode'/>
					<TouchableHighlight style={styles.button}
						underlayColor='#99d9f4'>
						<Text style={styles.buttonText}>Go</Text>
					</TouchableHighlight>
				</View>
				<TouchableHighlight style={styles.button}
						underlayColor='#99d9f4'>
						<Text style={styles.buttonText}>Location</Text>
				</TouchableHighlight>
				<Image source={require('image!house')} style={styles.image}/>
			</View>
		);
	}
}


var styles = StyleSheet.create({
	description: {
		marginBottom: 20,
		fontSize: 18,
		textAlign: 'center',
		color: '#656565'
	},
	container: {
		padding: 30,// 内间距
		marginTop: 65,// 外间距
		alignItems: 'center'
	},
	flowRight: {
	  flexDirection: 'row',
	  alignItems: 'center',
	  alignSelf: 'stretch'
	},
	buttonText: {
	  fontSize: 18,
	  color: 'white',
	  alignSelf: 'center'
	},
	button: {
	  height: 36,
	  flex: 1,
	  flexDirection: 'row',
	  backgroundColor: '#48BBEC',
	  borderColor: '#48BBEC',
	  borderWidth: 1,
	  borderRadius: 8,
	  marginBottom: 10,
	  alignSelf: 'stretch',
	  justifyContent: 'center'
	},
	searchInput: {
	  height: 36,
	  padding: 4,
	  marginRight: 5,
	  flex: 4,
	  fontSize: 18,
	  borderWidth: 1,
	  borderColor: '#48BBEC',
	  borderRadius: 8,
	  color: '#48BBEC'
	},
	image: {
		width: 217,
		height: 138
	}
});

module.exports = SearchPage;