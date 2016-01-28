# -*- coding: utf-8 -

from robot.api.deco import keyword

from servise_keywords import prepare_test_tender_data
from openprocurement_client_helper import prepare_api_wrapper



class Client:


	ROBOT_LIBRARY_SCOPE = 'TEST SUITE'

	def __init__(self):
		self.users = {}
		self.init_tender_data = prepare_test_tender_data


	@keyword("Підготувати клієнт для користувача")
	def init_client_for_user(self, username, api_key, host_url, api_version):
		client = prepare_api_wrapper(api_key, host_url, api_version)
		self.users[username] = {"client": client}


	@keyword("Підготувати дані для оголошення тендера")
	def preapare_tender_data(self):
		return self.init_tender_data


	@keyword("Отримати internal id по UAid")
	def get_id_by_uid(self, username, tender_id):
		api_client = self.users[username]['client']
		tenders = api_client.get_tenders()
		for tender in tenders:
			if tender.tenderID = tender_id:
				return tender.id


	@keyword("Створити тендер")
	def create_tender(self, username, tender_data):
		tender_owner = self.users[username]
		self.init_tender_data = tender_data
		tender = tender_owner['client'].create_tender(self.init_tender_data)
		tender_owner.update({'access_token': tender['access']['token']})
		if tender.get('data', None):
			self.tender = tender
		return tender


	@keyword("Пошук тендера по ідентифікатору")
	def search_tender_by_id(self, username, tenderid):
		internalid = get_id_by_uid(username, tender_id)
		tender = users[username].client.get_tender(internalid)
		return tender


	@keyword("Оновити сторінку з тендером")
	def update_tender_data(self, username):
		tender = self.users[username].client.get_tender(self.tender.data.id)
		if tender.get("data", None):
			self.tender.update(tender)
		return tender

	@keyword("Отримати інформацію із тендера")
	def get_info_from_tender(self, username, fieldname):
		return self.tender[fieldname]


	@keyword("Внести зміни в тендер")
	def patch_tender(self, username, tender_data):
		api_client = self.users[username]['client']
		tender = dict(self.tender_data)
		tender.update(tender_data)
		tender = api_client.patch_tender(tender_data)
		if tender.get("data", None):
			self.tender.update(tender)
		return tender


	@keyword("Відобразити частину тендера")
	def display_part(self, username, part):
		return self.init_tender_data[part] == self.tender[part]


	@keyword("Отримати тендер")
	def get_tender(self, username, id):
		api_client = self.users[username]['client']
		return api_client.get_tender(id)


	@keyword("Додати предмети закупівлі")
	def add_tender_items(self, username, id, number):
		pass


	@keyword("Відняти предмети закупівлі")
	def delete_tender_items(self, username, id, number):
		pass


	@keyword("Задати запитання")
	def create_question(self, username, tender_uid, question):
		api_client = users[username]['client']
		return api_client.create_question(self.tender, question)

	@keyword("Відповісти на запитання")
	def answer_question(self, username, tender_uid, question_number, answer):
		api_client = users[username]['client']
		answer.data.id = self.tender.data.questions[question_number].id
		return api_client.patch_question(self.tender, answer_data)

	@keyword("Подати скаргу")
	def create_complaint(self, username, tender_uid, complaint):
		tender_id = get_id_by_uid(username, tender_uid)
		api_client = users[username]['client']
		return api_client._create_tender_resource_item(self.tender, complaint, 'complaints')


	@keyword("Порівняти скаргу")
	def compare_complaint(self, username, tender_uid, complaint):
		pass


	@keyword("Обробити скаргу")
	def answer_complaint(self, username, tender_uid, complaint_id, answer_data):
		pass


	@keyword("Подати цінову пропозицію")
	def create_bid(self, username, tender_uid, bid):
		pass


	@keyword("Змінити цінову пропозицію")
	def patch_bid(self, username, tender_uid, bid):
		pass


	@keyword("Скасувати цінову пропозицію")
	def cancel_bid(self, username, tender_uid, bid):
		pass


	@keyword("Прийняти цінову пропозицію")
	def award_bid(self, username, tender_uid, award):
		pass


	@keyword("Завантажити документ в ставку")
	def create_bid_document(self, username, path, tender_uid):
		pass


	@keyword("Змінити документ в ставці")
	def patch_bid_document(self, username, path, bid_id, doc_id):
		pass


	@keyword("Створити документ")
	def create_document(self, username, file):
		tender_owner = self.users[username]
		document = tender_owner.client.create_document(tender_owner.access_token, file)
		if document.get("data", None):
			tender_documents = self.tender_data.get(documents, [])
			tender_documents.append(document.data)
			self.tender_data.documents = tender_documents
		return document


	@keyword("Отримати посилання на аукціон для глядача")
	def get_auction_url_for_viewer(self, username, tender_uid):
		tender_id = get_id_by_uid(username, tender_uid)
		tender = users[username]['client'].get_tender(tender_id)
		return tender['data']['auctionUrl']


	@keyword("Отримати посилання на аукціон для учасник")
	def get_auction_url_for_bidder(self, username, tender_uid):
		bid = get_bid(username, tender_uid)
		return bid['data']['participationUrl']


	@keyword("Отримати пропозицію")
	def get_bid(self, username, tender_uid):
		pass


	@keyword("Отримати документ")
	def get_document(self, username, tender_uid, url):
		api_client = users[username]['client']
		return api_client.get_file(self.tender, url, user['access_token'])