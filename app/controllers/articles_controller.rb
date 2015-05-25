class ArticlesController < ApplicationController
  def index
	@articles = Article.page(params[:page]).order("created_at desc")
	#@articles = Article.status_active
  end

  def new
	@article = Article.new
  end

  def edit
	@article = Article.find_by_id(params[:id])
  end


def import
  Article.import(params[:file])
  redirect_to root_url, notice: "Products imported."
end

def create

    @article = Article.new(params_article)

    if @article.save
        flash[:notice] = "Success Add Records"
        redirect_to action: 'index'

    else
        flash[:error] = "data not valid"
        render 'new'

    end

end

  def show
  	@article = Article.find_by_id(params[:id])
  	@comments = @article.comments.order("id desc")
  	@comment = Comment.new
    respond_to do |format|
      format.html
      format.pdf do
        pdf = ArticlePdf.new(@article)
        send_data pdf.render, filename: @article.title, type: 'application/pdf'
      end
    end
  end

def update

 @article = Article.find_by_id(params[:id])

 if @article.update(params_article)

    flash[:notice] = "Success Update Records"

    redirect_to action: 'index'

 else

    flash[:error] = "data not valid"

    render 'edit'

 end

end

def destroy

    @article = Article.find_by_id(params[:id])

    if @article.destroy

        flash[:notice] = "Success Delete a Records"

        redirect_to action: 'index'

    else

        flash[:error] = "fails delete a records"

        redirect_to action: 'index'

    end

end

  def import
    if Article.import(params[:file])
      redirect_to root_url, notice: "Article imported."
    else
      redirect_to root_url, error: "Please try again."
    end
  end

 private

    def params_article

        params.require(:article).permit(:title, :content, :status)

    end

end


