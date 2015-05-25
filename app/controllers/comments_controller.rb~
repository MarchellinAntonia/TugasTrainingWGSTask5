class CommentsController < ApplicationController
  def index
	@comments = Comments.all
	#@comments = Comments.comment_per_article_id
  end

  def new
	@comments = Comment.new
  end

  def edit
  end

def create
  	respond_to do |format|
		@comment = Comment.new(params_comment)
		if @comment.save
			format.js {@comments = Article.find_by_id(params[:comment][:article_id]).comments.order("id desc")}
		else
			format.js {@article = Article.find_by_id(params[:comment][:article_id])}
		end
	end
end

def update

 @comments = Comment.find_by_id(params[:id])

 if @comments.update(params_comment)

    flash[:notice] = "Success Update Records"

    redirect_to action: 'index'

 else

    flash[:error] = "data not valid"

    render 'edit'

 end

end

def destroy

    @comments = Comment.find_by_id(params[:id])

    if @comments.destroy

        flash[:notice] = "Success Delete a Records"

        redirect_to action: 'index'

    else

        flash[:error] = "fails delete a records"

        redirect_to action: 'index'

    end

end

private

    def params_comment

        params.require(:comment).permit(:article_id, :user_is, :content)

    end



end
