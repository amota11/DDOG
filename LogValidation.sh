#!/bin/bash

# FAST* APPROACH

# myLine matches config instructions for enabling logs (Notice the lack of #)
myLine="logs_enabled: true"
# $logMatch verifies that line 1122 is set to false   
logMatch=$(sudo grep -o "# logs_enabled: false" /etc/datadog-agent/datadog.yaml)     

# If the vars don't match, then logs are disabled. We proceed with the operation.
if [[ "$myLine" != "$logMatch" ]]; then
        while true; do                      # Using a "while-loop" to manage user decision and control input to just (Yy) or (Nn)
                read -r -p "Logs are not enabled. Would you like to enable them? (Y/N): " answer
                case $answer in
                        [Yy]* ) echo "Enabling logs now";
                                echo "...";
                                sudo sed -i "s|$logMatch|$myLine|" /etc/datadog-agent/datadog.yaml;     # Sed command finds and replaces the required line to enable logs in the config file
                                echo "...";
                                echo "Logs enabled.";
                                read -n 1 -s -r -p "Press any key to restart agent";                    # Thank you StackOverflow gods for giving me this line on my first search ;~;
                                echo "..."
                                echo "Restarting agent";
                                echo "...";
                                sudo service datadog-agent restart;                                     # Agent is restarted after editing /etc/datadog-agent/datadog.yaml
                                echo "..." ;
                                echo "Operation completed. Goodbye!";
                                exit 1;;
                        [Nn]* ) echo "Logs left disabled. Goodbye!"; exit 1;;
                        * ) echo "Please answer Y or N.";;
                esac
        done
else
        echo "Logs are already enabled!"                        # Might have to check this out later. The IF condition is too "ambiguous" to handle a case where logs are already enabled.
        echo "Goodbye!"
        exit 1
fi