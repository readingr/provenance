from json import dumps
from django.db.models import Count
from django.contrib.auth import login, authenticate
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.http import HttpResponse, HttpResponseForbidden
from django.shortcuts import render_to_response, get_object_or_404, redirect
from django.template.context import RequestContext
from django.utils.datastructures import MultiValueDictKeyError
from django.contrib.auth.models import Group, User
from django.core.paginator import Paginator, PageNotAnInteger, EmptyPage
from tastypie.models import ApiKey
from guardian.shortcuts import assign, remove_perm, get_perms_for_model
from guardian.shortcuts import get_groups_with_perms, get_objects_for_user, get_users_with_perms
from guardian.decorators import permission_required_or_403
from oauth_provider.models import Consumer
from prov.model import ProvBundle
from prov.model.graph import prov_to_dot
from prov.server.forms import ProfileForm, AppForm, BundleForm, SearchForm,ContactForm
from prov.settings import ANONYMOUS_USER_ID
from prov.server.models import Container
from prov.server.search import search_name, search_id, search_literal,\
    search_timeframe, search_any_text_field
#from django.core.cache import cache


PAGINATION_THRESHOLD = 20


def registration(request):
    if(request.user.is_authenticated()):
        return redirect(list_bundles)
    
    if request.method == 'POST':
        form = ProfileForm(request.POST)
        if form.is_valid():
            form.save()
            user = authenticate(username=form.cleaned_data['username'], password=form.cleaned_data['password'])
            login(request,user)
            messages.success(request, 'You have successfully registered!')
            if form.data['next']:
                return redirect(form.data['next'])
            return redirect('/')
        else:
            for error in form.non_field_errors():
                messages.error(request,error)
            return render_to_response('server/register.html',{'form': form, 'next': form.data['next']}, 
                                      context_instance=RequestContext(request))
            
    form = ProfileForm()
    if 'next' in request.GET:
        next_page = request.GET['next']
    else:
        next_page = ''
    return render_to_response('server/register.html', {'form': form, 'next': next_page}, 
                              context_instance=RequestContext(request))

#===============================================================================
# def get_perms_list(user,q_set):
#    content = ContentType.objects.get(app_label='server', model='container')
#    user_perm = UserObjectPermission.objects.filter(user_id=user.id, object_pk__in=q_set,content_type=content)\
#            .values('object_pk')
#    groups = user.groups.exclude(id=PUBLIC_GROUP_ID)
#    group_perm = GroupObjectPermission.objects.filter(group_id__in=groups, object_pk__in=q_set,content_type=content)\
#        .values('object_pk')
#    public_perm = GroupObjectPermission.objects.filter(group_id=PUBLIC_GROUP_ID, object_pk__in=q_set,content_type=content)\
#        .values('object_pk')
#    dict = {}
#    for i in public_perm:
#        dict[int(i['object_pk'])] = 0
#    for i in user_perm:
#        dict[int(i['object_pk'])] = i['user__count']
#    for i in group_perm:
#        if i['group__count'] > dict[i['object_pk']]:
#            dict[int(i['object_pk'])] = i['group__count']
#    return dict
#===============================================================================
#===============================================================================
# def _get_list_with_perms(user):
#    ''' A function returning a list containing entries which are 3-tuples representing
#    basic information about each bundle including the 'top level' permission.
#    Format of entry is: (BundleID, BundleName, PERMISSION_KEY)
#    Where PERMISSION_KEY takes values in between the First letter of each of the possible
#    permission for the Container model and 'p' which represent public.
#    PERMISSION_KEY takes the value of the top-level permission - ordered in increasing order:
#    'v'(view),'p'(public),'c'(change),'d'(delete),'a'(admin),'o'(own) it would take the value
#    of the 'biggest' permission that the user has for that bundle.
#    Example:
#    if user has view, change and delete and the Bundle is public - 'd'
#    if user has only view and Bundle is public - 'p'
#    if user has only view and Bundle is private - 'v'
#    '''
#    
#    bundles = {}
#    bundles_q = []
#    if user.is_anonymous() or user.id == ANONYMOUS_USER_ID:
#        bundles_q.append(('p', Container.objects.filter(public = True).select_related('content__rec_id')))
#    else:
#        bundles_q.append(('v', get_objects_for_user(user=user, 
#                                                    perms = ['view_container'], 
#                                                    klass=Container, any_perm=True).
#                          select_related('content__rec_id')))
#        bundles_q.append(('p', Container.objects.filter(public = True).select_related('content__rec_id')))
#        bundles_q.append(('c', get_objects_for_user(user=user, 
#                                                    perms = ['change_container'], 
#                                                    klass=Container, any_perm=True).
#                          select_related('content__rec_id')))
#        bundles_q.append(('d', get_objects_for_user(user=user, 
#                                                    perms = ['delete_container'], 
#                                                    klass=Container, any_perm=True).
#                          select_related('content__rec_id')))
#        bundles_q.append(('a', get_objects_for_user(user=user, 
#                                                    perms = ['admin_container'], 
#                                                    klass=Container, any_perm=True).
#                          select_related('content__rec_id')))
#        bundles_q.append(('o', Container.objects.filter(owner=user).select_related('content__rec_id')))
#    for i in bundles_q:
#        for j in i[1]:
#            bundles[j.id] = [j.id, j.content.rec_id, i[0]]        
#    bundles = bundles.values()
#    bundles.sort(reverse=True)
#    return bundles
#===============================================================================

def _pagination(paginator, page):
    ''' 
    Generates a list with size equal to the links that are displayed on the 
    pagination bar. Each element is interpreted as a flag of whether the link is 
    to be active(other pages) flag '-1', inactive(current page) flag '0' or 
    '...'(between long intervals) flag '-2'.
    '''
    interval_size = 3
    page = int(page)
    if paginator.num_pages <= 2 * interval_size + 1:
        page_list = [-1 for i in paginator.page_range]
        page_list[page-1] = 0
        return page_list
    page_list = paginator.page_range
    for i in range(interval_size):
        page_list[i] = -1
        page_list[paginator.num_pages - 1 - i] = -1
    page_list[interval_size] = -2
    page_list[paginator.num_pages - interval_size] = -2
    start = page - interval_size if page - interval_size > 0 else 1
    end = page + interval_size if page + interval_size < paginator.num_pages else paginator.num_pages
    for i in range(start,end + 1):
        page_list[i-1] = -1
    page_list[page-1] = 0
    return page_list

def list_bundles(request):
    if request.user.is_anonymous():
        user = User.objects.get(id=ANONYMOUS_USER_ID)
    else:
        user = request.user
    bundles = None
    choice = 0
    if request.method == 'POST':
        form = SearchForm(request.POST)
        if form.is_valid():
            choice = form.cleaned_data['choice']
            if choice == 'name':
                result = search_name(form.cleaned_data['name'])
                choice = 0
            elif choice == 'id':
                result = search_id(form.cleaned_data['id'])
                choice = 1
            elif choice == 'type':
                result = search_literal(form.cleaned_data['literal']+'prov#type', form.cleaned_data['value'])
                choice = 2
            elif choice == 'time':
                start_date = form.cleaned_data['start_time_date']
                start_time = form.cleaned_data['start_time_time']
                if start_date:
                    start = str(start_date) + 'T' + str(start_time)
                else:
                    start = None
                end_date = form.cleaned_data['end_time_date']
                end_time = form.cleaned_data['end_time_time']
                if end_date:
                    end = str(end_date) + 'T' + str(end_time)
                else:
                    end = None
                result = search_timeframe(start, end)
                choice = 3
            elif form.cleaned_data['choice'] == 'any':
                result = search_any_text_field(form.cleaned_data['any'])
                choice = 4
#            if result:
#            result = result.values_list('id', flat=True)
            '''Filter the result by the user permissions '''
            bundles = get_objects_for_user(user=user, perms = ['view_container'],
                                           klass=Container, any_perm=True).filter(id__in=result).\
                                           order_by('-id')
#            else:
#                bundles = []
#            cache.set(request.user.username+'_s', bundles)
            page = 1
        else:
            pass
            #bundles = cache.get(request.user.username+'_s')
    else:
        form = SearchForm()
        page = request.GET.get('page', 1)
#        if page:
#            pass
#            bundles = cache.get(request.user.username+'_s', Container.objects.none())
#        else:
#            pass
#            cache.delete(request.user.username+'_s')    
#        if not bundles:
        bundle_list = get_objects_for_user(user=user, perms = ['view_container'],
                                       klass=Container, use_groups=True,any_perm=True).\
                                       order_by('-id').select_related('content__rec_id', 'owner')
            #cache.set(request.user.username+'_s', bundles)
            
    paginator = Paginator(bundle_list, PAGINATION_THRESHOLD)
    
    ''' Change 'bundles to the actual page object'''
    try:
        bundles = paginator.page(page)
    except PageNotAnInteger:
        bundles = paginator.page(1)
        page = 1
    except EmptyPage:
        bundles = paginator.page(paginator.num_pages)
        page = paginator.num_pages
    return render_to_response('server/list_bundles.html', 
                                  {'bundles': bundles, 'page_list': _pagination(paginator, page),
                                   'form': form, 'choice': choice},
                                  context_instance=RequestContext(request))

@permission_required_or_403('view_container', (Container, 'pk', 'container_id'))
def bundle_detail(request, container_id):
    container = get_object_or_404(Container, pk=container_id)
    if request.method == 'POST':
            if not request.user.has_perm('delete_container', container):
                return HttpResponseForbidden()
            container.delete()
            messages.success(request, 'The bundle with ID ' + container.content.rec_id + ' was successfully deleted.')
            #cache.delete(request.user.username+'_l')
            return redirect(list_bundles)
    pdbundle = container.content
    counters = count_records_type(pdbundle)
    prov_g = pdbundle.get_prov_bundle() 
    prov_n = prov_g.get_provn()
    prov_json = dumps(prov_g, indent=4, cls=ProvBundle.JSONEncoder)
    licenses = container.license.all()
    can_delete = request.user.has_perm('delete_container', container)
    return render_to_response('server/private/bundle_detail.html',
                              {'bundle': container, 'prov_n': prov_n, 
                               'prov_json': prov_json, 'license': licenses,
                               'counters': counters, 'can_delete': can_delete},
                              context_instance=RequestContext(request))
    
@permission_required_or_403('view_container', (Container, 'pk', 'container_id'))
def bundle_svg(request, container_id):
    container = get_object_or_404(Container, pk=container_id)
    prov_g = container.content.get_prov_bundle()
    dot = prov_to_dot(prov_g)
    svg_content = dot.create(format='svg')
    return HttpResponse(content=svg_content, mimetype='image/svg+xml')
    
@login_required
def create_bundle(request):
    if request.method == 'POST':
            form = BundleForm(request.POST, request.FILES or None)
            if form.is_valid():
                container = form.save(owner=request.user)
                messages.success(request, 'The bundle was successfully created with ID ' + str(container.content.rec_id) + ".")
                #cache.delete(request.user.username+'_l')
                return redirect(list_bundles)
            else:
                for error in form.non_field_errors():
                    messages.error(request,error)
                return render_to_response('server/private/create_bundle.html',
                                          {'form': form}, 
                                          context_instance=RequestContext(request))
    return render_to_response('server/private/create_bundle.html',
                              {'form': BundleForm()},
                              context_instance=RequestContext(request))

@login_required
def api_key(request):
    key = None
    date = None
    try:
        api_key = ApiKey.objects.get(user=request.user)
    except ApiKey.DoesNotExist:
        api_key = None
    
    if request.method == 'POST':
        try:
            action = request.POST['action']
            if action == 'delete' and api_key:
                api_key.delete()
                api_key = None
                messages.success(request, 'The API key was successfully deleted.')
            elif action == 'generate':
                if not api_key:
                    api_key = ApiKey.objects.create(user=request.user)
                else:
                    api_key.key = ApiKey.generate_key(api_key)
                    api_key.save()
                messages.success(request, 'The API key was successfully generated.')
        except MultiValueDictKeyError:
            pass

    if api_key:
        key = api_key.key
        date = api_key.created
        
    return render_to_response('server/private/api_key.html',{'key': key, 'date': date,},
                              context_instance=RequestContext(request))

def _update_perms(target, role, container):
    ''' Function to update the permissions of the 'target'(User or Group)
    for a given container in correspondence to a given role.
    role can take several values corresponding to the following permissions:
        none - no permissions
        Reader - 'view'
        Contributor - 'view' + 'change'
        Editor - 'view' + 'change' + 'delete'
        Administrator - 'view' + 'change' + 'delete' + 'admin'
    '''
    perms = get_perms_for_model(Container)
    l_perm = []
    for i in range(len(perms)):
        l_perm.append(perms[i].codename)
    for permission in l_perm:
            remove_perm(permission, target, container)
    if role == 'none':
        if target == Group.objects.get(name='public'):
            container.public = False
            container.save()
        return
    assign('view_container', target, container)
    if role == 'Reader':
        if target == Group.objects.get(name='public'):
            container.public = True
            container.save()
        return
    assign('change_container', target, container)
    if role == 'Contributor':
        return
    assign('delete_container', target, container)
    if role == 'Editor':
        return
    assign('admin_container', target, container)
        
@permission_required_or_403('admin_container', (Container, 'pk', 'container_id'))
def admin_bundle(request, container_id):
    container = get_object_or_404(Container, pk=container_id)
    if request.method == 'POST':
        try:
            name = request.POST['name']
            role = request.POST['role']
            perm_type = request.POST['perm_type']
            if role not in ('none','Reader','Contributor','Editor','Administrator'):
                raise Exception
            if perm_type == 'user':
                target = User.objects.get(username=name)
                _update_perms(target, role, container)
            elif perm_type == 'group':
                target = Group.objects.get(name=name)
                _update_perms(target, role, container)
        except User.DoesNotExist:
            messages.error(request, 'User does not exist!')
        except Group.DoesNotExist:
            messages.error(request, 'Group does not exist!')
        except Exception:
            pass

    initial_list = get_users_with_perms(container, attach_perms = True, with_group_users=False)
    users={}
    for user in initial_list:
        users[user] = len(initial_list[user])
    initial_list = get_groups_with_perms(container, attach_perms=True)
    public = False
    groups={}
    for group in initial_list:
        groups[group] = len(initial_list[group])
        if group.name == 'public':
            public = True
    all_users = [user.username for user in User.objects.all() if user.id != ANONYMOUS_USER_ID]
    all_users.sort()
    all_groups=[group.username for group in Group.objects.all() if group.name != 'public']
    all_groups.sort()    
    return render_to_response('server/private/admin_bundle.html',
                              {'bundle': container, 'public': public,
                               'users': users, 'groups': groups,
                               'all_users': all_users, 'all_groups': all_groups},
                              context_instance=RequestContext(request))

@login_required
def register_app(request):
    if request.method == 'POST':
        form = AppForm(request.POST)
        if form.is_valid():
            consumer = form.save()
            consumer.user = request.user
            consumer.generate_random_codes()
            messages.success(request, 'The app ' + consumer.name + ' was successfully added to your list.')
            return redirect(manage_apps)
    else:
        form = AppForm()
    return render_to_response('server/private/register_app.html',
                              {'form': form},
                              context_instance=RequestContext(request))
    
@login_required
def manage_apps(request):
    if request.method == 'POST':
        consumer = get_object_or_404(Consumer, pk=request.POST['app_id'])
        if request.POST['status'] == 'Pending':
            status = 1
        elif request.POST['status'] == 'Accepted':
            status = 2
        elif request.POST['status'] == 'Canceled':
            status = 3
        elif request.POST['status'] == 'Rejected':
            status = 4
        consumer.status = status
        consumer.save()
        messages.success(request, 'The Key ' + consumer.key + ' status was successfully updated.')
        
    apps = request.user.consumer_set.all()
    return render_to_response('server/private/manage_apps.html', 
                              {'apps': apps}, context_instance=RequestContext(request))

@login_required   
def oauth_authorize(request, token, callback, params):
    from oauth_provider.forms import AuthorizeRequestTokenForm
    return render_to_response('server/oauth_authorize.html',
                              {'name': token.consumer.name, 'description': token.consumer.description, 
                               'form': AuthorizeRequestTokenForm(), 'oauth_token': token.key},
                              context_instance=RequestContext(request))

#===============================================================================
# def search(request):
#    bundles = []
#    if request.method == 'POST':
#        form = SearchForm(request.POST)
#        if form.is_valid():
#            if form.cleaned_data['choice'] == 'name':
#                result = search_name(form.cleaned_data['string'])
#            elif form.cleaned_data['choice'] == 'id':
#                result = search_id(form.cleaned_data['string'])
#            elif form.cleaned_data['choice'] == 'type':
#                result = search_literal(form.cleaned_data['string'])
#            elif form.cleaned_data['choice'] == 'time': 
#                result = search_timeframe(form.cleaned_data['start_time'], form.cleaned_data['end_time'])
#            elif form.cleaned_data['choice'] == 'any':
#                result = search_any_text_field(form.cleaned_data['string'])
#            result = result.values_list('id', flat=True)
#            all_bundles = _get_list_with_perms(request.user)
#            bundles = filter(lambda row: row[0] in result, all_bundles)
#            cache.set(request.user.username+'_s', bundles)
#    else:
#        form = SearchForm()
#    page = request.GET.get('page', None)
#    if page:
#        bundles = cache.get(request.user.username+'_s', [])
#    else:
#        cache.delete(request.user.username+'_s')
#    paginator = Paginator(bundles, PAGINATION_THRESHOLD)
#    try:
#        bundles = paginator.page(page)
#    except PageNotAnInteger:
#        bundles = paginator.page(1)
#        page = 1
#    except EmptyPage:
#        bundles = paginator.page(paginator.num_pages)
#        page = paginator.num_pages
#    return render_to_response('server/search.html', {'form': form, 'bundles': bundles,
#                                                     'page_list':_pagnition(paginator, page)},
#                              context_instance=RequestContext(request))
#===============================================================================

def contact(request):
    if request.method == 'POST':
        form = ContactForm(request.POST)
        if form.is_valid():
            try:
                form.save()
                messages.success(request, 'Thank you for your email. We will get back to you soon.')
                form = ContactForm()
            except:
                messages.error(request, 'We are sorry, but there was a problem with the email server. '\
                              + 'Please try again later.')
    else:
        form = ContactForm()
        if not request.user.is_anonymous() or request.user.id == -1:
            form.fields['sender'].initial = request.user.email
    return render_to_response('server/contact.html', {'form': form}, 
                              context_instance=RequestContext(request))
    

    
# Analytic functions - TODO: Moved to a separate module
from prov.persistence.models import PDRecord
from prov.model import PROV_RECORD_TYPES, PROV_REC_BUNDLE
from collections import Counter

PROV_RECORD_MAP = dict(PROV_RECORD_TYPES)

def count_records_type(pdbundle):
    query = PDRecord.objects.filter(bundle=pdbundle).values('rec_type').annotate(count=Count('id')).values_list('rec_type', 'count')
    counter = Counter(dict(query))
    if PROV_REC_BUNDLE in counter:
        sub_bundles = PDRecord.objects.filter(bundle=pdbundle, rec_type=PROV_REC_BUNDLE)
        query = PDRecord.objects.filter(bundle__in=sub_bundles).values('rec_type').annotate(count=Count('id')).values_list('rec_type', 'count')
        counter.update(dict(query))
    result = [(PROV_RECORD_MAP[key], value) for key, value in counter.items()]
    return result