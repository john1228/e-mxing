(function($) {
	
	$.extend({
		qReport: function(configs) {
			var buffer = {},
				INDEX_TABLE = $.extend({
					"1": [0, 519487],
					"2": [0, 519488],
					"3": [0, 519489]
				}, configs || {}),
				timer = null;
			var sendReport = function(url) {
					var img = new Image();
					img.src = url;
					img.onload = img.onerror = function() {
						this.onload = this.onerror = null
					};
					img = null
				};

			function sendAll() {
				var msg = [];
				for (var i in buffer) {
					msg.push(buffer[i] + "-" + INDEX_TABLE[i][0] + "-" + INDEX_TABLE[i][1] + "_" + buffer[i])
				}
			}
			return function(key, value) {
				if (INDEX_TABLE[key]) {
					buffer[key] = (buffer[key] || 0) + (value || 1);
					if (timer) {
						window.clearTimeout(timer)
					}
					timer = window.setTimeout(sendAll, 500)
				}
			}
		}()
	});
	
})(jQuery);