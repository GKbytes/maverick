class maverick_security (
	$selinux = "permissive",
	$firewall = true,
	$fail2ban = false,
	$rkhunter = false,
	$clamav = false,
	$ssl = true,
	) {
    
    # Create data directory
    file { "/srv/maverick/data/security":
    	ensure		=> directory,
    	owner		=> "mav",
    	group		=> "mav",
    	mode		=> "755",
    }
    
    ### Turn selinux on to at least permissive by default
    if ($operatingsystem == "CentOS") or ($operatingsystem == "RedHat") or ($operatingsystem == "Fedora") {
	    class { "selinux":
			mode => $selinux,
	    }
    }
    
    ### Configure firewall.  More rules are set with each applicaton
	if $firewall {
		class { "maverick_security::firewall": }
	}

	### Configure/enable ssh client, including various mandatory keys
	class { "maverick_security::ssh": }

	### Configure fail2ban for ssh
	if $fail2ban {
		class { "maverick_security::fail2ban": }
	} else {
		service_wrapper { "fail2ban":
			ensure		=> stopped,
			enable		=> false
		}
	}

	### Configure scanners like rkhunter and clamav
	class { "maverick_security::scanners":
		rkhunter		=> $rkhunter,
		clamav			=> $clamav,
	}
	
	### Configure base SSL environment
	class { "maverick_security::ssl": }

}