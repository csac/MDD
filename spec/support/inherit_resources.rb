# encoding: UTF-8
describe "inherit_resources" do
  shared_examples_for 'inherit_resources with' do |kind, methods|
    model = kind.classify.constantize
    collection = kind.pluralize
    let(collection.to_sym) { model.page }
    let(kind.to_sym) { Fabricate kind.to_sym }
    let(:administrator) { Fabricate :administrator }

    before do
      sign_in(administrator)
    end

    if methods.include?('new')
      describe "GET new" do
        before do
          get :new
        end

        it "assign a new #{kind} as #{kind}" do
          assigns(kind.to_sym).class.should eq(model)
          assigns(kind.to_sym).should be_new_record
        end

        it "should be success" do
          response.should be_success
        end
      end
    end

    if methods.include?('show')
      describe "GET show" do
        before do
          @object = send(kind.to_sym)
          id = @object.id
          get :show, id: id
        end
        it "assigns the requested #{kind} as @#{kind}" do
          assigns(kind.to_sym).should eq(@object)
        end
        it "should be success" do
          response.should be_success
        end
      end
    end

    if methods.include?('index')
      describe "GET index" do
        before do
          get :index
        end

        it "assigns all #{collection} as @#{collection}" do
          assigns(collection.to_sym).should == send(collection.to_sym)
        end

        it "should be success" do
          response.should be_success
        end
      end
    end

    if methods.include?('edit')
      describe "GET edit" do
        before do
          @object = send(kind.to_sym)
          id = @object.id
          get :edit, id: id
        end
        it "assigns the requested #{kind} as @#{kind}" do
          assigns(kind.to_sym).should eq(@object)
        end
        it "should be success" do
          response.should be_success
        end
      end
    end

    # TODO
    if methods.include?('update')
      describe "PUT update" do
        before do
          @object = send(kind.to_sym)
        end
        describe "with valid params" do
          before do
            id = @object.id
            put :update, id: id, kind => {'these' => 'params'}
          end

          it "assigns the requested #{kind} as @#{kind}" do
            assigns(kind).should eq(@object)
          end

          it "redirects to the #{kind}" do
            response.should redirect_to(send("edit_#{kind}_path", @object))
          end

          it "assigns a flash message" do
            [I18n.t("flash.admin.#{collection}.update.notice"), I18n.t("flash.actions.update.notice", resource_name: kind.humanize)].should include(flash[:notice])
          end
        end

        describe "with invalid params" do
          before do
            id = @object.id
            put :update, id: id, kind => {'these' => 'params'}
          end

          it "assigns a updated but unsaved #{kind} as @#{kind}" do
            assigns(kind.to_sym).should == @object
          end

          it 'should render edit template' do
            response.should render_template(:edit)
          end

        end
      end
    end

    # TODO
    if methods.include?('create')
      describe "POST create" do
        describe "with valid params" do
          before :each do
            @object.should_receive(:save).and_return(true)
            post :create, kind => {'these' => 'params'}
          end

          it "assigns a newly created #{kind} as @#{kind}" do
            assigns(kind.to_sym).should == @object
          end

          it "redirects to the created #{kind}" do
            response.should redirect_to(send("#{kind}_path", @object))
          end

          it "assigns a flash message" do
            [I18n.t("flash.admin.#{collection}.create.notice"), I18n.t("flash.actions.create.notice", resource_name: kind.humanize)].should include(flash[:notice])
          end
        end
        describe "with invalid params" do
          before :each do
            @object.should_receive(:save).and_return(false)
            @object.should_receive(:errors).any_number_of_times.and_return(error)
            post :create, kind => {'these' => 'params'}
          end

          it "assigns a newly created but unsaved #{kind} as @#{kind}" do
            assigns(kind.to_sym).should == @object
          end

          it 'should render new template' do
            response.should render_template(:new)
          end
        end
      end
    end

    if methods.include?('destroy')
      describe "GET destroy" do
        before do
          @object = send(kind.to_sym)
          delete :destroy, id: @object.id
        end

        it "assigns all #{kind} as @#{kind}" do
          assigns(kind.to_sym).should == @object
        end

        it 'should have a notification message' do
          flash[:notice].should eq(I18n.t("flash.actions.destroy.notice", resource_name: kind.humanize))
        end

        it "should be success" do
          response.should redirect_to(send(:"#{collection}_path"))
        end
      end
    end

  end
end
