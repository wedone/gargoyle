#!/usr/bin/haserl
<?
	# This program is copyright © 2008 Eric Bishop and is distributed under the terms of the GNU GPL
	# version 2.0 with a special clarification/exception that permits adapting the program to
	# configure proprietary "back end" software provided that all modifications to the web interface
	# itself remain covered by the GPL.
	# See http://gargoyle-router.com/faq.html#qfoss for more information
	eval $( gargoyle_session_validator -c "$COOKIE_hash" -e "$COOKIE_exp" -a "$HTTP_USER_AGENT" -i "$REMOTE_ADDR" -r "login.sh" -t $(uci get gargoyle.global.session_timeout) -b "$COOKIE_browser_time"  )
	gargoyle_header_footer -h -s "status" -p "connections" -c "internal.css" -j "conntrack.js table.js" -i -n httpd_gargoyle firewall qos_gargoyle
?>

<script>
<!--
<?
	qos_enabled=$(ls /etc/rc.d/*qos_gargoyle 2>/dev/null)
	if [ -n "$qos_enabled" ] ; then
		echo "var qosEnabled = true;"
	else
		echo "var qosEnabled = false;"
	fi

	echo "var qosMarkList = [];"
	if [ -e /etc/qos_class_marks ] ; then
		awk '{ print "qosMarkList.push([\""$1"\",\""$2"\",\""$3"\",\""$4"\"]);" }' /etc/qos_class_marks
	fi
?>
//-->
</script>


<form>
	<fieldset>
		<legend class="sectionheader">当前连接</legend>

		<div>
			<label for="refresh_rate" class="narrowleftcolumn">刷新频率:</label>
			<select id="refresh_rate" class="rightcolumn" >
				<option value="2000">2 秒</option>
				<option value="10000">10 秒</option>
				<option value="30000">30 秒</option>
				<option value="60000">60 秒</option>
				<option value="never">不刷新</option>
			</select>
		</div>
		<div>
			<label for="bw_units" class="narrowleftcolumn" onchange="updateConnectionTable()">带宽单位:</label>
			<select id="bw_units" class="rightcolumn">
				<option value="mixed">自动(混合)</option>
				<option value="KBytes">KBytes</option>
				<option value="MBytes">MBytes</option>
				<option value="GBytes">GBytes</option>
			</select>
		</div>
		<div>
			<label for="host_display" class="narrowleftcolumn" onchange="updateConnectionTable()">主机名显示:</label>
			<select id="host_display" class="rightcolumn">
				<option value="hostname">显示主机名</option>
				<option value="ip">显示主机IP</option>
			</select>
		</div>

		<div id="connection_table_container"></div>
		<div style="width:375px">
			<p>不显示本地主机和路由器之间的连接.</p>
		</div>
	</fieldset>
</form>

<script>
<!--
	initializeConnectionTable();
//-->
</script>

<?
	gargoyle_header_footer -f -s "status" -p "connections"
?>
