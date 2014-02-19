<?php
namespace wcf\form;
use wcf\system\exception\UserInputException;
use wcf\system\mail\Mail;
use wcf\system\request\LinkHandler;
use wcf\system\WCF;
use wcf\util\HeaderUtil;
use wcf\util\OptionUtil;
use wcf\util\StringUtil;

/**
 * Shows Contact Form.
 *
 * @author	Jeffrey Reichardt
 * @copyright	2012-2014 DevLabor UG (haftungsbeschränkt)
 * @license	GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 * @package	com.devlabor.wcf.form.contact
 * @subpackage	form
 */
class ContactForm extends MailForm {
	const AVAILABLE_DURING_OFFLINE_MODE = OFFLINE_CONTACT_FORM;

	/**
	 * @see	\wcf\page\AbstractPage::$enableTracking
	 */
	public $enableTracking = true;
		
	/**
	 * @see	wcf\form\RecaptchaForm::$useCaptcha
	 */
	public $useCaptcha = CONTACT_USE_CAPTCHA;

	/**
	 * @see	wcf\page\AbstractPage::$activeMenuItem
	 */
	public $activeMenuItem = 'wcf.header.menu.contact';

	/**
	 * mail address of selected category
	 * @var    string
	 */
	public $categoryMail = '';
	
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

		if (isset($_POST['categoryMail'])) $this->categoryMail = StringUtil::trim($_POST['categoryMail']);

		if (WCF::getUser()->userID) {
			$this->email = WCF::getUser()->email;
		}
	}

	/**
	 * @see	wcf\form\IForm::validate()
	 */
	public function validate() {
		parent::validate();

		$availableCategories = OptionUtil::parseSelectOptions(CONTACT_MAIL_CATEGORIES);
		if (CONTACT_MAIL_CATEGORIES && !empty($availableCategories)) {
			if (empty($this->categoryMail)) {
				throw new UserInputException('categoryMail');
			}

			if (!in_array($this->categoryMail, array_keys($availableCategories))) {
				throw new UserInputException('categoryMail', 'invalid');
			}
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
	 * @see	wcf\page\IPage::assignVariables()
	 */
	public function assignVariables() {
		parent::assignVariables();

		WCF::getTPL()->assign(array(
			'categoryMail' => $this->categoryMail,
			'availableCategories' => OptionUtil::parseSelectOptions(CONTACT_MAIL_CATEGORIES)
		));
	}

	/**
	 * @see wcf\form\IForm::save()
	 */
	public function save() {	
		AbstractForm::save();

		// set recipient
		if (!empty($this->categoryMail)) {
			$to = array($this->categoryMail);
		}
		else {
			$to = array(MAIL_FROM_NAME => MAIL_ADMIN_ADDRESS);
		}

		// set mail from
		if (WCF::getUser()->userID) {
			$from = array(WCF::getUser()->username => WCF::getUser()->email);
		}
		else {
			$from = $this->email;
		}

		// build mail
		$mail = new Mail($to, $this->subject, $this->message, $from);
		$mail->setLanguage(WCF::getLanguage());
		$mail->setHeader('Reply-To: '.$this->email);
		$mail->send();

		$this->saved();

		// forward to index
		HeaderUtil::delayedRedirect(LinkHandler::getInstance()->getLink(''), WCF::getLanguage()->get('wcf.contact.redirect.message'));
		exit;
	}

	
	/**
	 * @see	wcf\page\IPage::show()
	 */
	public function show() {
		// enable captcha only for guests
		if (CONTACT_USE_CAPTCHA) {
			$this->useCaptcha = !(bool)(WCF::getUser()->userID);
		}

		// don't trigger MailForm::show()	
		AbstractForm::show();
	}	
}
