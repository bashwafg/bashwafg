windows-shell-setup-localaccount() { local name="" password="" plaintext="true" description="" display_name="" group="Users"; while [[ $# -gt 0 ]]; do case "$1" in Name) shift; name="$1" ;; Password) shift; password="$1" ;; PlainText) shift; plaintext="$1" ;; Description) shift; description="$1" ;; DisplayName) shift; display_name="$1" ;; Group) shift; group="$1" ;; esac; shift; done; [[ -z "$name" ]] && return; [[ -z "$display_name" ]] && display_name="$name"; echo -e "\t\t\t\t<LocalAccount wcm:action=\"add\">"; [[ -n "$password" ]] && echo -e "\t\t\t\t\t<Password>\n\t\t\t\t\t\t<Value>$password</Value>\n\t\t\t\t\t\t<PlainText>$plaintext</PlainText>\n\t\t\t\t\t</Password>"; [[ -n "$description" ]] && echo -e "\t\t\t\t\t<Description>$description</Description>"; echo -e "\t\t\t\t\t<DisplayName>$display_name</DisplayName>\n\t\t\t\t\t<Group>$group</Group>\n\t\t\t\t\t<Name>$name</Name>\n\t\t\t\t</LocalAccount>"; }