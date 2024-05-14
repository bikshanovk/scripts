#Checks network availability between workstation (Windows) and servers (4 ENVs)

$Domain_A_PROM=,'srv_s_1','srv_s_2','srv_s_3','srv_s_4','srv_s_5','srv_s_6','srv_s_7','srv_s_8','srv_s_9','srv_s_10','srv_s_11','srv_s_12','srv_s_13','srv_s_14','srv_s_15','srv_s_16','srv_s_17','srv_s_18','srv_s_19','srv_s_20','srv_s_21','srv_s_22','srv_s_23','srv_s_24','srv_s_25','srv_s_26','srv_s_27','srv_s_28','srv_s_29','srv_s_30','srv_s_31','srv_s_32','srv_s_33','srv_s_34','srv_s_35','srv_s_36','srv_s_37','srv_s_38','srv_s_39','srv_s_40','srv_s_41','srv_s_42','srv_s_43','srv_s_44','srv_s_45','srv_s_46','srv_s_47','srv_s_48','srv_s_49','webdb.cgs.sbrf.ru','erkzm.cgs.sbrf.ru','erkzk.cgs.sbrf.ru','v-webMQ-8r2-01';
$Domain_S_PROM=,"srv_1","srv_2","srv_3","srv_4","srv_5","srv_6","srv_7","srv_8","srv_9","srv_10","srv_11","srv_12","srv_13","srv_14","srv_15","srv_16","srv_17","srv_18","srv_19","srv_20","srv_21","srv_22","srv_23","srv_24","srv_25","srv_26","srv_27","srv_28","srv_29","srv_30","srv_31","srv_32","srv_33","srv_34","srv_35","srv_36","srv_37","srv_38","srv_39","srv_40","srv_41","srv_42","srv_43","srv_44","srv_45","srv_46","srv_47","srv_48","srv_49","srv_50","srv_51","srv_52","srv_53","srv_54","srv_55","srv_56","srv_57","srv_58","srv_59","srv_60","srv_61","srv_62","srv_63","srv_64","srv_65","srv_66","srv_67","srv_68","srv_69","srv_70","srv_71","srv_72","srv_73","srv_74","srv_75","srv_76","srv_77","srv_78","srv_79","srv_80","srv_81","srv_82","srv_83","srv_84","srv_85","srv_86","srv_87","srv_88","srv_89","srv_90","srv_91","srv_92","srv_93","srv_94","srv_95","srv_96","srv_97","srv_98","srv_99","srv_100","srv_101","srv_102","srv_103","srv_104","srv_105","srv_106","srv_107","srv_108","srv_109","srv_110","srv_111","srv_112","srv_113","srv_114","srv_115","srv_116","srv_117","srv_118","srv_119","srv_120","srv_121","srv_122","srv_123","srv_124","srv_125","srv_126","srv_127","srv_128","srv_129","srv_130","srv_131","srv_132","srv_134","srv_133","srv_135","srv_136","srv_137","srv_138","srv_139","srv_140","srv_141","srv_142","srv_143","srv_144","srv_145","srv_146","srv_147","srv_148","srv_149";
$Domain_S_PSI="srv_p_1","srv_p_2","srv_p_3","srv_p_4","srv_p_5","srv_p_6","srv_p_7","srv_p_8","srv_p_9","srv_p_10","srv_p_11","srv_p_12","srv_p_13","srv_p_14","srv_p_15","srv_p_16","cerus1","cerus2","webtest-ld1","webtest";
$Domain_S_HF=,"srv_p_54","srv_p_55","srv_p_56","srv_p_57","srv_p_58","srv_p_59","srv_p_60","srv_p_61","srv_p_62","srv_p_63","srv_p_64","srv_p_65","srv_p_81","srv_p_82","srv_p_66","srv_p_67","srv_p_70","webtest-ld3","webtest";
################################
#$arr=$Domain_S_PSI;
#$arr=$Domain_S_HF;
$arr=$Domain_S_PROM;
#$arr=$Domain_S_HF;

Function psp { param($InputObject = $null) BEGIN {$status = $True} PROCESS
 {
   if ($InputObject -and $_)
   {
       throw 'ParameterBinderStrings\AmbiguousParameterSet'
   }
   elseif ($InputObject -or $_)
   {
       $processObject = $(if ($InputObject) {$InputObject} else {$_})
       if( (Test-Connection $processObject -Quiet -count 1))
       {
           write-host  "OK    ${processObject}" -ForegroundColor DarkGreen
       }
       else
       {
           write-host "FAIL  ${processObject}" -ForegroundColor red
           $status = $False
       }
   }
   else
   {
       throw 'ParameterBinderStrings\InputObjectNotBound'
   }
# next processObject
 }
}

foreach ($Computer in $arr)
{
   psp $Computer
}
