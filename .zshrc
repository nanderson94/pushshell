# Populate and uncomment this:
# export PB_API_KEY="YourAPIKeyHere";

# Usage: pushbullet <message> [title]
# Usage: echo "hi" | pushbullet [title]
pushbullet() {
	# Did they give us a key?
	if [ -e $PB_API_KEY ]; then
		echo "You must set PB_API_KEY in your environment before using this function!";
		echo "Example: export PB_API_KEY=\"YourAPIKeyHere\"";
		exit 1;
	fi

	# Set up our message contents
	while read line; do
		lines="${lines}${line}";
	done

	if [ -e $lines ]; then
		export message="${1}";
		if [ -e $2 ]; then
			export title="${USER}@${HOST}";
		else
			export title="${2}";
		fi
	else
		export message="${lines}";
		if [ -e $1 ]; then
			export title="${USER}@${HOST}";
		else
			export title="${1}";
		fi
	fi

	# Generate a JSON string with safe escaping, etc
	# TODO: Find a pure shell/GNU solution for this
	jsonstr=$(node -e "console.log(JSON.stringify({type:\"note\",title:process.env.title,body:process.env.message}))");

	# Do the CURL request
	# TODO: Error checking
	response=$(curl --silent -u "$PB_API_KEY:" \
		-X POST "https://api.pushbullet.com/v2/pushes" \
		--header "Content-Type: application/json" \
		--data-binary "${jsonstr}");
}