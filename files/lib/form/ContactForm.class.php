<?php
namespace wcf\form;
use wcf\data\user\User;
use wcf\system\mail\Mail;
use wcf\system\request\LinkHandler;
use wcf\system\WCF;
use wcf\util\HeaderUtil;

/**
 * Shows Contact Form.
 *
 * @author	Jeffrey Reichardt
 * @copyright	2012-2013 DevLabor UG (haftungsbeschränkt)
 * @license	GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 * @package	com.devlabor.wcf.form.contact
 * @subpackage	form
 */
class ContactForm extends MailForm {

	/**
	 * @see	\wcf\page\AbstractPage::$enableTracking
	 */
	public $enableTracking = true;
		
	/**
	 * @see	wcf\form\RecaptchaForm::$useCaptcha
	 */
	public $useCaptcha = CONTACT_USE_CAPTCHA;
	
	/**
	 * @see wcf\page\IPage::readParameters()
	 */
	public function readParameters() {
		AbstractForm::readParameters();

		// don't trigger MailForm::readParameters()
	}
	
	/**
	 * @see wcf\form\IForm::readFormParameters()
	 */
	public function readFormParameters() {
		parent::readFormParameters();

		if (WCF::getUser()->userID) {
			$this->email = WCF::getUser()->email;
		}
	}
	
	/**
	 * @see	wcf\page\IPage::readData()
	 */
	public function readData() {
		AbstractForm::readData();

		// don't trigger MailForm::readData()
	}	

	/**
	 * @see wcf\form\IForm::save()
	 */
	public function save() {	
		AbstractForm::save();
	
		// build mail
		$mail = new Mail(array(MAIL_FROM_NAME => MAIL_ADMIN_ADDRESS), $this->subject, $this->message);
		$mail->setLanguage(WCF::getLanguage());
		$mail->setHeader('Reply-To: '.$this->email);
		$mail->send();

		$this->saved();

		// forward to index
		HeaderUtil::delayedRedirect(null, WCF::getLanguage()->get('wcf.contact.redirect.message'));
		exit;
	}

	/**
	 * @see	wcf\page\AbstractPage::$activeMenuItem
	*/
	public $activeMenuItem = 'wcf.header.menu.contact';
	
	/**
	 * @see	wcf\page\IPage::show()
	 */
	public function show() {
		AbstractForm::show();
		
		// don't trigger MailForm::show()
	}	
}
