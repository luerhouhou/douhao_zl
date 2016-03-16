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
 
function urlForQueryAndPage(key, value, pageNumber) {
	var data = {
		country: 'uk',
		pretty: '1',
		encoding: 'json',
		listing_type: 'buy',
		action: 'search_listings',
		page: pageNumber
	};
	data[key] = value;

	var querystring = Object.keys(data)
	.map(key => key + '=' + encodeURIComponent(data[key]))
	.join('&');

	return 'http://api.nestoria.co.uk/api?' + querystring;
};

class SearchPage extends React.Component {

	constructor(props) {
			super(props);
			this.state = {
				searchString: 'london', // 状态变量，初始值为london
				isLoading: false
			};
		}

	onSearchTextChanged(event) {
		console.log('onSearchTextChanged');
		this.setState({ searchString: event.nativeEvent.text });
		console.log(this.state.searchString);
	}

	_executeQuery(query) { // 下划线说明是私有的
		console.log(query);
		this.setState({ isLoading: true });
	}

	onSearchPressed() {
		var query = urlForQueryAndPage('place_name', this.state.searchString, 1);
		this._executeQuery(query);
	}

	render() {
		var spinner = this.state.isLoading ?
					( <ActivityIndicatoeIOS hidden='true' size='large'/> ) : ( <View />);
		console.log('SearchPage.render');

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
						value={this.state.searchString}
						onChange={this.onSearchTextChanged.bind(this)}
						placeholder='Search via name or postcode'/>
					<TouchableHighlight style={styles.button}
						underlayColor='#99d9f4'>
						<Text style={styles.buttonText}
							onPress={this.onSearchPressed.bind(this)}
						>Go</Text>
					</TouchableHighlight>
				</View>
				<TouchableHighlight style={styles.button}
						underlayColor='#99d9f4'>
						<Text style={styles.buttonText}>Location</Text>
				</TouchableHighlight>
				<Image source={require('image!house')} style={styles.image}/>
				{spinner}

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