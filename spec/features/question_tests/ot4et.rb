=begin
После посещения 100 страниц на наличие ошибки как протестировать наличие добавления 2 файлов,
применения порядка 20 различных способов написания теста,написания вопроса на 
http://stackoverflow.com/questions/40922507/testing-nested-forms-with-capybara-and-cocoon
пришел к выводу что застрял надолго.
В результате поиска кто на что грешил - simple_form poltergeist database-cleaner

Что узнал

Для применения добавления еще 1 файла cocoon использует js,так что добавляем опцию js: true по умолчанию
конечно я пытался проделать что-то вроде этого 
   page.execute_script("$('.add_fields').click()")
но и для применения данного кода необходим js

Применение
  если не ставить опцию js: true то такой тест проходит

    fill_in "Title", with: "Test question"
    fill_in "Body", with: "Anybody"
    inputs = all('input[type"file"]')
    inputs[0].set("#{Rails.root}/spec/rails_helper.rb"
    click_on "Create"
    
    expect(page).to have_link "rails_helper.rb", href: "/uploads/attachment/file/2/rails_helper.rb"

  и такой тест проходит

    fill_in "Title", with: "Test question"
    fill_in "Body", with: "Anybody"
    attach_file "File","#{Rails.root}/spec/rails_helper.rb"
    click_on "Create"
    
    expect(page).to have_link "rails_helper.rb", href: "/uploads/attachment/file/2/rails_helper.rb"

При добавлении опции js: true простой тест не проходит,хотя вроде бы ничего лишнего

    fill_in "Title", with: "Test question"
    fill_in "Body", with: "Anybody"
    attach_file "File","#{Rails.root}/spec/rails_helper.rb"
    click_on "Create"
    
    expect(page).to have_link(или даже have_content) "rails_helper.rb"
    ССЫЛКИ НЕТ

HTML иммеет структуру
  <input class="file optional" 
  name="question[attachments_attributes][0][file]"
  id="question_attachments_attributes_0_file" type="file">

Пытался выделить селектор по типу Id name чтобы капибара нашла форму,
но она находит толко при отсутствии js: true
Окончательный вариант моего умозаключения представлен в тесте "add_files_to_question"
Тест на answer add files писать не вижу смысла ,он такой же по умолчанию
=end