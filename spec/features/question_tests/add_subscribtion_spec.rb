require 'features_helper'
# все проходит, проблема заключалась в названии ссылок
# unsubscribe i subscribe имеют общий корень и капибара путалась потому что видела обе ссылки
# поменял на Unsubscribe i Subscribe
# проблема номер 2 заключалась то что не видит блок .question да и любой другой
# проблема не критична потому что на странице вопрос единственный
# если бы мы подписывались на массив комментов ответа
# то тогда нам нужен был бы блок а-ля #answer-#{answer.id}
feature "Create subscribtion", %q{
  All user can subscribe to question,
  and after than they receive answer
  notification to email 
}, :js do
  
  let(:user)       { create(:user) }
  let(:other_user) { create(:user) }
  let!(:question)  { create(:question, user: user) }

  scenario "non-authenticate user can't subsribe to question" do
    visit question_path(question)

    expect(page).to_not have_link "Subscribe"
    expect(page).to_not have_link "Unsubscribe"
  end

  feature "authenticate user" do
    feature "have not subscribe to question" do
      before do
        log_in other_user
        visit question_path(question)
      end

      scenario "can subscribe to question" do
        click_on "Subscribe"

        expect(page).to have_link("Unsubscribe")
        expect(page).to_not have_link("Subscribe")
      end
    end

    feature "already have subscribe to question" do
      before do
        question.subscribtions.create(user: user)
        log_in user
        visit question_path(question)
      end

      scenario "can't subscribe to question second time" do
        expect(page).to_not have_link("Subscribe")
        expect(page).to have_link("Unsubscribe")
      end

      scenario "can unsubscribe to question" do
        click_on "Unsubscribe"

        expect(page).to have_link("Subscribe")
        expect(page).to_not have_link("Unsubscribe")
      end
    end
  end
end