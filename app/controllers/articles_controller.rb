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
	format.csv {render text: Article.to_csv}
	#format.csv {send_data Article.to_csv}
        format.xlsx {send_data Article.to_xlsx({},@article.id)}
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

def download_file
    if params[:article].present?
      @articles = Article.where(:id => params[:article])
      @comments = @articles.first.comments
    else
      @articles = Article.all
      @comments = Comment.all
    end

    xlsx = Axlsx::Package.new
    wb = xlsx.workbook
    wb.add_worksheet(name: "Articles") do |sheet|
      sheet.add_row ["Title", "Body", "Created At", "Updated At"]
      @articles.each do |article|
        sheet.add_row [ article.title, article.content, article.created_at, article.updated_at]
      end
    end
    wb.add_worksheet(name: "Comments") do |sheet|
      sheet.add_row ["Article ID", "Body", "Created At", "Updated At"]
      @comments.each do |comment|
        sheet.add_row [comment.article_id, comment.content, comment.created_at, comment.updated_at]
      end
    end

    send_data xlsx.to_stream.read, type: "application/xlsx", filename: "complete.xlsx"
  end

def download_satuan
    @article = Article.find_by_id(params[:article])
    @comments = @article.comments.order("id desc")

    xlsx = Axlsx::Package.new
    wb = xlsx.workbook
    wb.add_worksheet(name: "Articles") do |sheet|
      sheet.add_row ["Title", "Content", "Created At", "Updated At"]
      sheet.add_row [@article.title, @article.content, @article.created_at, @article.updated_at]
    end
    wb.add_worksheet(name: "Comments") do |sheet|
      sheet.add_row ["Article ID", "User_is", "Content", "Created At", "Updated At"]
      @comments.each do |comment|
        sheet.add_row [comment.user_is, comment.article_id, comment.content, comment.created_at, comment.updated_at]
      end
    end

    send_data xlsx.to_stream.read, type: "application/xlsx", filename: "artikelSatuan.xlsx"
  end

  # POST
  def import
    raise 'Nothing to import' unless params[:sample].present?

    total_row = 0
    spreadsheet = open_spreadsheet(params[:sample])

    spreadsheet.sheets.each_with_index do |sheet, index|
      spreadsheet.default_sheet = spreadsheet.sheets[index]

      header = Array.new
      spreadsheet.row(1).each { |row| header << row.downcase.tr(' ', '_') }
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        new_row = eval("#{spreadsheet.default_sheet.singularize}").new(row)

        raise 'Failed to save, maybe invalid column' unless new_row.save!

        total_row += 1
      end
    end

    respond_to do |f|
      f.html { redirect_to articles_path, :notice => "Importing #{total_row} records successfully" }
    end
  end

  private
    def open_spreadsheet(file)
      case File.extname(file.original_filename)
        when '.csv' then Roo::Csv.new(file.path, {extension: :csv, file_warning: :ignore })
        when '.xls' then Roo::Excel.new(file.path, {extension: :xls, file_warning: :ignore })
        when '.xlsx' then Roo::Excelx.new(file.path, {extension: :xlsx, file_warning: :ignore })
        else raise "Unknown file type: #{file.original_filename}"
      end
    end

 private

    def params_article

        params.require(:article).permit(:title, :content, :status)

    end





end


