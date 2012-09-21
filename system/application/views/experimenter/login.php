<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en-US" xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Experimenter Login</title>
	<link href="<?= base_url().'assets/css/login.css'?>" rel="stylesheet" type="text/css" />
        <link href="<?=base_url().'assets/css/smoothness/jquery.ui.all.css'?>" rel="stylesheet" type="text/css" />
        <link href="<?=base_url().'assets/css/smoothness/jquery.ui.autocomplete.css'?>" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="<?=base_url().'assets/js/jquery-ui-1.8.4.custom.min.js'?>"></script>
	<script type="text/javascript" src="<?=base_url().'assets/js/jquery-1.4.2.min.js'?>"></script>
</head>

<body>
    <div id="content">
        <div id="login_border">
            <h2>EXPERIMENTER LOGIN</h2>
             <label id="error"><?=$error?></label>
             <?=form_open(base_url().'experimenter/login')?>
                <table>
                    <tr>
                        <td>
                        <label class="field_label">Username</label>
                        <?=form_input(array('class'=>'text_field', 'name'=>'login', 'value'=>set_value('login'), 'id'=>'text-field'))?>
                        </td>
                    </tr>
                    <tr>
                        <td class="field_error">
                            <?=form_error('login')?>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label class="field_label">Password</label>
                            <?=form_password(array('class'=>'text_field', 'name'=>'password', 'value'=>set_value('password'), 'id'=>'text-field'))?>
                            
                        </td>
                    </tr>
                    <tr>
                        <td class="field_error">
                            <?=form_error('password')?>
                        </td>
                    </tr>
                </table>
            <?=form_submit(array('name'=>'submit', 'value'=>'Login', 'id'=>'button'))?>
            <?=form_close()?>

        </div> <!-- content div -->
    </div> <!-- wrapper div -->
</body>
</html>
